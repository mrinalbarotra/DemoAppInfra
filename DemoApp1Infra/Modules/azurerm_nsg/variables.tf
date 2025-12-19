variable "nsgs" {
  description = "Map of Nsgs with their rules"
  type = map(object({
    name                       = string
    resource_group_name        = string
    location                   = string
    security_rules = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string


    }))             


  }))

}

variable "tags" {
  type = map(string)
  
}
