variable "vnets" {
    description = "map of virtual networks to create"
    type = map(object({
        name = string
        resource_group_name = string
        location = string
        address_space = list(string)
    }))

}

variable "tags" {
    type = map(string)
  
}