variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type = string
}

variable "instances" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_ssh_key" {
  type = object({
    username   = string
    public_key = string
  })
}

variable "os_disk" {
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "custom_data" {
  type    = string
  default = null
}

variable "tags" {
  type = map(string)
}

variable "appgw_backend_pool_id" {
  type    = string
  default = null
}