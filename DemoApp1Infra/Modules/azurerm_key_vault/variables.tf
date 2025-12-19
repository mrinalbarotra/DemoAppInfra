variable "kvs" {
  description = "Map of Key Vaults to create"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    tenant_id                   = string
    soft_delete_retention_days  = number
    purge_protection_enabled    = bool
    sku_name                    = string

    access_policies = list(object({
      tenant_id            = string
      object_id            = string
      key_permissions      = list(string)
      secret_permissions   = list(string)
      storage_permissions  = list(string)
    }))
  }))
}

