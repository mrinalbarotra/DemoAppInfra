variable "rgs" {
  description = "Map of resource groups to create"
  type = map(object({
    name     = string
    location = string
  }))
}

variable "vnets" {
  description = "map of virtual networks to create"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
  }))

}

variable "mssqlservers" {
  description = ",map of mssqlservers"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    version             = string
    minimum_tls_version = string
    azuread_administrator = object({
      login_username = string
      ad_group_name  = string
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
    name                = string
    resource_group_name = string
    location            = string
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

variable "vmss" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string

    sku       = string
    instances = number

    subnet_key = string

    admin_username = string
    role           = string
    admin_ssh_key = object({
      username = string
    })

    os_disk = object({
      caching              = string
      storage_account_type = string
    })

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    custom_data = optional(string)
  }))
}


variable "kvs" {
  type = map(object({
    name                       = string
    location                   = string
    resource_group_name        = string
    tenant_id                  = string
    sku_name                   = string
    purge_protection_enabled   = bool
    soft_delete_retention_days = number

    access_policy = map(object({
      tenant_id           = string
      object_id           = string
      key_permissions     = list(string)
      storage_permissions = list(string)
      secret_permissions  = list(string)

    }))


  }))
}

variable "app_gws" {
  type = map(object({
    app_gw_name         = string
    resource_group_name = string
    location            = string

    sku_name     = string
    sku_tier     = string
    sku_capacity = number

    gw_ip_config_name = string

    frontend_port_name = string
    frontend_port_port = number

    frontend_ip_config_name = string

    backend_address_pool_name = string

    backend_http_settings_name                  = string
    backend_http_settings_cookie_based_affinity = string
    backend_http_settings_port                  = number
    backend_http_settings_protocol              = string
    backend_http_settings_request_timeout       = number

    http_listener_name     = string
    http_listener_protocol = string

    request_routing_rule_name      = string
    request_routing_rule_priority  = number
    request_routing_rule_rule_type = string

  }))


}


variable "ilbs" {
  type = map(object({
    lb_name             = string
    location            = string
    resource_group_name = string
    sku                 = string
    subnet_key          = string

    # frontend_ip_config_name   = string
    # backend_pool_name         = string

    # rule_name                 = string
    rule_protocol = string
    frontend_port = number
    backend_port  = number
  }))
}

variable "acrs" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string
    # georeplications_location = string
    # zone_redundancy_enabled  = bool
  }))

}