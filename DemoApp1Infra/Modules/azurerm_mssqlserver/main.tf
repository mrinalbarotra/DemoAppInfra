resource "azurerm_mssql_server" "mssqlserver" {
  for_each                      = var.mssqlservers
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  version                       = each.value.version             #"12.0"
  minimum_tls_version           = each.value.minimum_tls_version #"1.2"
  public_network_access_enabled = false

    azuread_administrator {
    login_username = each.value.azuread_administrator.login_username
    object_id      = data.azuread_group.sql_admin[each.key].object_id
    azuread_authentication_only  = true
  }


  tags = var.tags
}
