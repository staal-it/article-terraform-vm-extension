output "script_execution" {
  value     = "powershell -ExecutionPolicy Unrestricted -File second.ps1"
  sensitive = true
}

output "files" {
  value = [azurerm_storage_blob.second_script.url]
}
