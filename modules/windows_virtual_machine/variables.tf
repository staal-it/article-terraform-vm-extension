variable "name" {
  type = string
}

variable "identity_ids" {
  type    = set(string)
  default = []
}

variable "size" {
  type = string
  default = "Standard_D2s_v3"
}

variable "subnet_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}