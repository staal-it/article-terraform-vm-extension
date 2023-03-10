output "script_execution" {
  value     = "powershell -ExecutionPolicy Unrestricted -File first.ps1"
  sensitive = true
}

output "files" {
  value = [azurerm_storage_blob.first_script.url]
}
