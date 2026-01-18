data "azuread_group" "mssql_admin" {
  display_name = "mssql-admin"
}

data "azurerm_mssql_server" "sql1" {
  name                = "dev-demoapp1-centralindia-mssqlserver1"
  resource_group_name = "dev-demoapp1-centralindia-rg1"
}
