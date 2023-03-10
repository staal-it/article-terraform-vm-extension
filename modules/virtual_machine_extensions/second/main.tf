resource "azurerm_storage_blob" "second_script" {
  name                   = "second.ps1"
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_account_container_name
  type                   = "Block"
  source                 = "${path.module}/files/second.ps1"
  content_md5            = filemd5("${path.module}/files/second.ps1")
}