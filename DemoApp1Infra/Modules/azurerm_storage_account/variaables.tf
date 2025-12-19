variable "stgs" {
  description = "Map of storage accounts"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    account_tier        = string
    tags                = map(string)
  }))


}
