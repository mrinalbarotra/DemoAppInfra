resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku       = var.sku
  instances = var.instances

  admin_username = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_ssh_key.username
    public_key = var.admin_ssh_key.public_key
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  network_interface {
    name    = "${var.name}-nic"
    primary = true

    ip_configuration {
      name      = "${var.name}-ipconfig"
      primary  = true
      subnet_id = var.subnet_id
      
      application_gateway_backend_address_pool_ids = var.appgw_backend_pool_id != null ? [var.appgw_backend_pool_id] : []
      
    #   public_ip_address {
    #     name = "${var.name}-pip"
    #   }
    }
  }

  custom_data = var.custom_data != null ? base64encode(var.custom_data) : null

  tags = var.tags
}
