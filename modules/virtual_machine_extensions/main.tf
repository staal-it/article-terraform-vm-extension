module "first" {
  source = "./first"

  storage_account_name           = var.storage_account_name
  storage_account_container_name = var.storage_account_container_name
}

module "second" {
  source = "./second"

  storage_account_name           = var.storage_account_name
  storage_account_container_name = var.storage_account_container_name
}

resource "azurerm_storage_blob" "combined_script" {
  name                   = "combined_script.ps1"
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_account_container_name
  type                   = "Block"
  source_content = join("\n", [
    module.first.script_execution,
    module.second.script_execution
  ])
}

resource "azurerm_virtual_machine_extension" "vm-extension" {
  name                 = "vm-extension"
  virtual_machine_id   = var.vm_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
"fileUris": ${jsonencode(concat(
  [azurerm_storage_blob.combined_script.url],
  module.first.files,
  module.second.files,
))}
    }
  SETTINGS
protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File combined_script.ps1",
      "managedIdentity" : { "objectId": "${var.vm_managedidentity_object_id}" }
    }
  PROTECTED_SETTINGS

}
