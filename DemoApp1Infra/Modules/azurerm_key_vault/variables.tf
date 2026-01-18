# variable "kvs" {
#   description = "Map of Key Vaults to create"
#   type = map(object({
#     name                        = string
#     location                    = string
#     resource_group_name         = string
#     tenant_id                   = string
#     soft_delete_retention_days  = number
#     purge_protection_enabled    = bool
#     sku_name                    = string

#     access_policies = list(object({
#       tenant_id            = string
#       object_id            = string
#       key_permissions      = list(string)
#       secret_permissions   = list(string)
#       storage_permissions  = list(string)
#     }))
#   }))
# }

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "soft_delete_retention_days" {
  type = number
}

variable "purge_protection_enabled" {
  type = bool
}

variable "sku_name" {
  type = string
}

variable "access_policy" {
  type = map(object({
    tenant_id = string
    object_id = string
    key_permissions = list(string)
    storage_permissions = list(string)
    secret_permissions = list(string)
  }))
}

variable "tags" {
  type = map(string)
}

variable "tenant_id" {
  type = string
}
