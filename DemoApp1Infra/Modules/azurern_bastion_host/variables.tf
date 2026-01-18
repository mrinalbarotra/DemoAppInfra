variable "name" {
  type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "ipconfigname" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "public_ip_address_id" {
    type = string
}

variable "tags" {
    type = map(string) 
}