variable "rgs" {
  description = "Map of resource groups to create"
  type = map(object({
    name        = string
    location    = string
  }))
}

variable "tags" {
  description = "Tags"
  type = map(string)
  
}