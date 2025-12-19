resource "azurerm_mssql_database" "mssqldatabase" {
  for_each     = var.mssqldatabases
  name         = each.value.name
  server_id    = var.server_id
  collation    = each.value.collation
  license_type = each.value.license_type
  max_size_gb  = each.value.max_size_gb
  sku_name     = each.value.sku_name
  enclave_type = each.value.enclave_type

  tags = var.tags

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}
