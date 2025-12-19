
# data "azurerm_key_vault_secret" "ssh_pub_key" {
#   for_each = var.vms
#   name         = each.value.ssh_key_name
#   key_vault_id = each.value.key_vault_id
# }

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = try(each.value.public_ip_id, null)
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vms
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  admin_ssh_key {
    username   = each.value.admin_ssh_key.username
    public_key = each.value.admin_ssh_key.public_key
  }

  os_disk {
    caching              =  each.value.os_disk.caching #"ReadWrite"
    storage_account_type =  each.value.os_disk.storage_account_type #"Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher #"Canonical"
    offer     = each.value.source_image_reference.offer  #"0001-com-ubuntu-server-jammy"
    sku       = each.value.source_image_reference.sku   #"22_04-lts"
    version   = each.value.source_image_reference.version   #"latest"
  }

  custom_data = base64encode(each.value.custom_data)
  
  tags = var.tags

}
  #   #!/bin/bash
  #   apt-get update -y
  #   apt-get install -y nginx
  #   systemctl enable nginx
  #   systemctl start nginx
  # EOF
  # )

