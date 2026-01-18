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
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  # tenant_id = var.tenant_id
  soft_delete_retention_days = var.soft_delete_retention_days #value must be between 7 to 90
  purge_protection_enabled   = var.purge_protection_enabled   #Boolean true/false
  sku_name                   = var.sku_name                   # standard or premium

  dynamic "access_policy" {
    for_each = var.access_policy
    content {
      tenant_id           = access_policy.value.tenant_id
      object_id           = access_policy.value.object_id #Entra ID
      storage_permissions = access_policy.value.storage_permissions
      key_permissions     = access_policy.value.key_permissions
      secret_permissions  = access_policy.value.secret_permissions
    }
  }

  tags = var.tags
}

