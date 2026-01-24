variable "lb_name" {}
variable "location" {}
variable "resource_group_name" {}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "subnet_id" {
  type = string
}

# variable "frontend_ip_config_name" {}

# variable "private_ip_allocation" {
#   type    = string
#   default = "Dynamic"
# }

# variable "private_ip_address" {
#   type    = string
#   default = null
# }

# variable "backend_pool_name" {}

# variable "probe_name" {}
# variable "probe_protocol" {
#   type    = string
#   default = "Tcp"
# }
# variable "probe_port" {
#   type = number
# }
# variable "probe_interval" {
#   type    = number
#   default = 5
# }
# variable "probe_count" {
#   type    = number
#   default = 2
# }

# variable "rule_name" {}
variable "rule_protocol" {
  type    = string
  default = "Tcp"
}
variable "frontend_port" {
  type = number
}
variable "backend_port" {
  type = number
}

variable "tags" {
  type = map(string)
}
