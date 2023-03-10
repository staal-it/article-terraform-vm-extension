variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "ZRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

variable "blob_readers" {
  type    = map(string)
  default = {}
}

variable "blob_file_systems" {
  type        = list(string)
  description = "List of blob file systems."
  default     = []
}