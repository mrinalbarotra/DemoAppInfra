variable "vms" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    size                = string
    admin_username      = string

    public_ip_id = optional(string)

    admin_ssh_key = object({
      username = string
      public_key = string
    })

    os_disk = object({
      caching = string
      storage_account_type = string
    })

    source_image_reference = object({
      publisher = string
      offer = string
      sku = string
      version = string
    })

    custom_data = optional(string)
  
  }))
}

variable "tags" {
  type = map(string)
}