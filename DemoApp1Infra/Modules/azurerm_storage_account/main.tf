resource "azurerm_storage_account" "stg" {
  for_each                 = var.stgs
  name                     = each.value.name
  resource_group_name      = each.value.azurerm_resource_group
  location                 = each.value.azurerm_resource_group
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags = each.value.tags
}
