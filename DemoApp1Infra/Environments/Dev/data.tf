data "azuread_group" "mssql_admin" {
  display_name = "mssql-admin"
}

# data "azurerm_mssql_server" "sql1" {
#   name                = "dev-demoapp1-centralindia-mssqlserver1"
#   resource_group_name = "dev-demoapp1-centralindia-rg1"
# }

data "azurerm_key_vault" "kv" {
  name                = "rsa-demo1-kv"
  resource_group_name = "rsa_demo1"
}

data "azurerm_key_vault_secret" "vmss_ssh_pubkey" {
  name         = "ssh-vm-demo1-public-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

