locals {
  project_name = "tfdemovmextensions"
  storage_account_container_name = "vm-scripts"
}

resource "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "vm_managed_identity" {
  location            = var.location
  name                = "mi-${local.project_name}"
  resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${local.project_name}"
    resource_group_name = azurerm_resource_group.resource_group.name
    location            = var.location
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "storage_account" {
  source              = "./modules/storage_account"
  name                = "stg${local.project_name}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location

  blob_readers      = { mi = azurerm_user_assigned_identity.vm_managed_identity.principal_id }
  blob_file_systems = [local.storage_account_container_name]
}

module "vm" {
  source = "./modules/windows_virtual_machine"

  name                = "vm-${local.project_name}"
  resource_group_name = azurerm_resource_group.resource_group.name
  subnet_id           = azurerm_subnet.subnet.id
  location            = var.location
  identity_ids        = [azurerm_user_assigned_identity.vm_managed_identity.id]
}

module "vm_extension" {
  source = "./modules/virtual_machine_extensions"

  vm_id                          = module.vm.id
  vm_managedidentity_object_id   = azurerm_user_assigned_identity.vm_managed_identity.principal_id

  storage_account_name           = module.storage_account.name
  storage_account_container_name = local.storage_account_container_name
}
