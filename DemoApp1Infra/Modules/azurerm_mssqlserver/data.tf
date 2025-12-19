data "azuread_group" "sql_admin" {
  for_each     = var.mssqlservers
  display_name = each.value.azuread_administrator.ad_group_name
}

data "azurerm_mssql_server" "sql1" {
  name                = "dev-demoapp1-centralindia-mssqlserver1"
  resource_group_name = "dev-demoapp1-centralindia-rg1"

}