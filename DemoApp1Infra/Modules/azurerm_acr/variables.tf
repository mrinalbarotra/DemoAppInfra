variable "acrs" {
    type = map(object({
      name = string
    resource_group_name = string
    location = string
    sku = string
    georeplications = optional(list(object({
        location = string
        zone_redundancy_enabled = bool
        tags = optional(map(string()),{})
    })),[])
    })) 
}