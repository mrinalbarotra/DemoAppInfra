locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "dev"
  }

  vms = {
    vm1 = {
      name                = "dev-demoapp1-centralindia-frontendvm"
      location            = "centralindia"
      resource_group_name = "dev-demoapp1-centralindia-rg1"
      size                = "Standard_B2s"
      admin_username      = "azureuser"
      subnet_id           = module.subnets.subnet_ids["subnet1"]
      public_ip_id        = module.pip.public_ip_ids["pip1"]

      admin_ssh_key = {
        username   = "azureuser"
        public_key = file("/home/Mrinal/Documents/VSCode/Terraform/SSH_KEY/id_rsa_demoapp1.pem.pub")
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      custom_data = <<EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF
    }

    vm2 = {
      name                = "dev-demoapp1-centralindia-backendvm"
      location            = "centralindia"
      resource_group_name = "dev-demoapp1-centralindia-rg1"
      size                = "Standard_B2s"
      admin_username      = "azureuser"
      subnet_id           = module.subnets.subnet_ids["subnet2"]

      admin_ssh_key = {
        username   = "azureuser"
        public_key = file("/home/Mrinal/Documents/VSCode/Terraform/SSH_KEY/id_rsa_demoapp1.pem.pub")
      }

      os_disk = {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
      }

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      custom_data = <<EOF
#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
EOF
    }
  }
}