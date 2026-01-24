
# since these variables are re-used - a locals block makes this more maintainable
# locals {
#   backend_address_pool_name      = "${azurerm_virtual_network.example.name}-beap"
#   frontend_port_name             = "${azurerm_virtual_network.example.name}-feport"
#   frontend_ip_configuration_name = "${azurerm_virtual_network.example.name}-feip"
#   http_setting_name              = "${azurerm_virtual_network.example.name}-be-htst"
#   listener_name                  = "${azurerm_virtual_network.example.name}-httplstn"
#   request_routing_rule_name      = "${azurerm_virtual_network.example.name}-rqrt"
#   redirect_configuration_name    = "${azurerm_virtual_network.example.name}-rdrcfg"
# }

resource "azurerm_application_gateway" "network" {
  name                = var.app_gw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier     #"Standard_v2"
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = var.gw_ip_config_name
    subnet_id = var.gw_ip_config_subnet_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port_port #80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_config_name
    public_ip_address_id = var.frontend_ip_config_public_ip_address_id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = var.backend_http_settings_cookie_based_affinity #"Disabled"
    # path                  = "/path1/" #optinal Backend path override
    port                  = var.backend_http_settings_port #80
    protocol              = var.backend_http_settings_protocol #"Http"
    request_timeout       = var.backend_http_settings_request_timeout #60
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_config_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = var.http_listener_protocol   #"Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = var.request_routing_rule_priority   #9 #Required for Standard_V2 SKU. The lower number, higher the priority
    rule_type                  = var.request_routing_rule_rule_type   #"Basic"
    http_listener_name         = var.http_listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }

  tags = var.tags
}