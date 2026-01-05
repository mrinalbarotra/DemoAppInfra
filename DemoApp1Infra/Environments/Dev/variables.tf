variable "rgs" {
  description = "Map of resource groups to create"
  type = map(object({
    name        = string
    location    = string
  }))
}

variable "vnets" {
    description = "map of virtual networks to create"
    type = map(object({
        name = string
        resource_group_name = string
        location = string
        address_space = list(string)
    }))

}

variable "mssqlservers" {
    description = ",map of mssqlservers"
    type = map(object({
      name = string
      resource_group_name= string
      location = string
      version = string
      minimum_tls_version = string
      azuread_administrator = object({
        login_username = string
        ad_group_name = string
      })
    })) 
}

variable "subnets" {
  description = "Map of subnets to be created"
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
      }))
}

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

variable "mssqldatabases" {
  type = map(object({
    name         = string
    collation    = string #"SQL_Latin1_General_CP1_CI_AS"
    license_type = string #"LicenseIncluded"
    max_size_gb  = number #2
    sku_name     = string #"S0"
    enclave_type = string #"VBS"
  }))

}

variable "pips" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string #Basic or Standard
  }))
}


