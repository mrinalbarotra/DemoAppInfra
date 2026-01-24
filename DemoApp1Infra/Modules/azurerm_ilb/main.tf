resource "azurerm_lb" "ilb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "${var.lb_name}-feipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "ilb" {
  name            = "${var.lb_name}-beaddpool"
  loadbalancer_id = azurerm_lb.ilb.id
}

resource "azurerm_lb_probe" "ilb" {
  name                = "${var.lb_name}-probe"
  loadbalancer_id     = azurerm_lb.ilb.id
  protocol            = "Tcp"
  port                = "80"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "ilb" {
  name                           = "${var.lb_name}-ilbrule"
  loadbalancer_id                = azurerm_lb.ilb.id
  protocol                       = var.rule_protocol
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "${var.lb_name}-feipconfig"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilb.id]
  probe_id                       = azurerm_lb_probe.ilb.id
}


# #Create an Internal Load Balancer to distribute traffic to the
# # Virtual Machines in the Backend Pool
# resource "azurerm_lb" "example" {
#   name                = var.load_balancer_name
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                          = "frontend-ip"
#     subnet_id                     = azurerm_subnet.example.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# # Create a Backend Address Pool for the Load Balancer
# resource "azurerm_lb_backend_address_pool" "example" {
#   loadbalancer_id = azurerm_lb.example.id
#   name            = "test-pool"
# }

# # Create a Load Balancer Probe to check the health of the 
# # Virtual Machines in the Backend Pool
# resource "azurerm_lb_probe" "example" {
#   loadbalancer_id = azurerm_lb.example.id
#   name            = "test-probe"
#   port            = 80
# }

# # Create a Load Balancer Rule to define how traffic will be
# # distributed to the Virtual Machines in the Backend Pool
# resource "azurerm_lb_rule" "example" {
#   loadbalancer_id                = azurerm_lb.example.id
#   name                           = "test-rule"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   disable_outbound_snat          = true
#   frontend_ip_configuration_name = "frontend-ip"
#   probe_id                       = azurerm_lb_probe.example.id
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
# }