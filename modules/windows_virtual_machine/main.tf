resource "time_offset" "one_month" {
  offset_months = 1
}
resource "time_offset" "two_months" {
  offset_months = 2
}

resource "random_password" "random_password" {
  length           = 16
  special          = true
  override_special = "~!@#$%^&*_-+=|(){}[]:;<>,.?"
  min_numeric      = 1
  min_upper        = 1
  min_lower        = 1
  min_special      = 1

  keepers = {
    last_changed_date = time_offset.one_month.rfc3339
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_virtual_machine" {
  name                = var.name
  computer_name       = "my-computer"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = "adminuser2"
  admin_password      = random_password.random_password.result

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 ? [1] : []

    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}