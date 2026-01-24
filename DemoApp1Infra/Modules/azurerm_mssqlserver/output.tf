# output "server_ids" {
#   description = "Map of SQL Server IDs"
#   value = {
#     for k, s in azurerm_mssql_server.mssqlserver :
#     k => s.id
#   }
# }
output "server_ids" {
  value = {
    for k, v in azurerm_mssql_server.mssqlserver :
    k => v.id
  }
}
