# provider "azurerm" {
#   features {
#     key_vault {
#       purge_soft_delete_on_destroy    = true
#       recover_soft_deleted_key_vaults = true
#     }
#   }
# }

# data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    for_each = var.kvs
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = true
  #tenant_id                   = data.azurerm_client_config.current.tenant_id
  tenant_id = each.value.tenant_id
  soft_delete_retention_days  = each.value.soft_delete_retention_days  #value must be between 7 to 90
  purge_protection_enabled    = each.value.purge_protection_enabled   #Boolean true/false

  sku_name = each.value.sku_name  # standard or premium

  dynamic "access_policy" {
    for_each = each.value.access_policies
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id #Entra ID
      key_permissions     = access_policy.value.key_permissions
      secret_permissions  = access_policy.value.secret_permissions
      storage_permissions = access_policy.value.storage_permissions
    }
  }
}