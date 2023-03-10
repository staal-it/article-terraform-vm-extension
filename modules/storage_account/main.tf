
resource "azurerm_storage_account" "storage_account" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  access_tier                     = var.access_tier
  min_tls_version                 = "TLS1_2"
}

resource "azurerm_role_assignment" "storage_blob_data_reader" {
  for_each = var.blob_readers

  scope                            = azurerm_storage_account.storage_account.id
  role_definition_name             = "Storage Blob Data Reader"
  principal_id                     = each.value
  skip_service_principal_aad_check = true
}

resource "azurerm_storage_container" "file_systems" {
  for_each             = toset(var.blob_file_systems)

  name                 = each.value
  storage_account_name = azurerm_storage_account.storage_account.name
}