output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.ilb.id
}

output "private_ip" {
  value = azurerm_lb.ilb.frontend_ip_configuration[0].private_ip_address
}

output "ilb_id" {
  value = azurerm_lb.ilb.id
}