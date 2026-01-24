variable "app_gw_name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "sku_name" {
    type = string
}

variable "sku_tier" {
    type = string
}

variable "sku_capacity" {
    type = string
}

variable "gw_ip_config_name" {
    type = string
}

variable "gw_ip_config_subnet_id" {
    type = string
}

variable "frontend_port_name" {
    type = string
}

variable "frontend_port_port" {
    type = string
}

variable "frontend_ip_config_name" {
    type = string
}

variable "frontend_ip_config_public_ip_address_id" {
    type = string
}

variable "backend_address_pool_name" {
    type = string
}

variable "backend_http_settings_name" {
    type = string
}

variable "backend_http_settings_cookie_based_affinity" {
    type = string
}

variable "backend_http_settings_port" {
    type = number
}

variable "backend_http_settings_protocol" {
    type = string
}

variable "backend_http_settings_request_timeout" {
    type = number
  
}

variable "http_listener_name" {
    type = string
}

variable "http_listener_protocol" {
    type = string
}

variable "request_routing_rule_name" {
    type = string
}

variable "request_routing_rule_priority" {
    type = number
}

variable "request_routing_rule_rule_type" {
    type = string
}

variable "tags" {
    type = map(string)
}