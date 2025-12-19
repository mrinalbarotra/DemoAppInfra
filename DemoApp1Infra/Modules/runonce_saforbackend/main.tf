resource "azurerm_resource_group" "berg" {
  name     = "rg-tfstate"
  location = "central india"
}

resource "azurerm_storage_account" "besa" {
  name                     = "tfstatebackendsa"
  resource_group_name      = azurerm_resource_group.berg.name
  location                 = azurerm_resource_group.berg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "becontainer" {
    depends_on = [ azurerm_storage_account.besa ]
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.besa.id
  container_access_type = "private"
}