variable "pips" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string #Basic or Standard
  }))
}

variable "tags" {
  type = map(string)

}
