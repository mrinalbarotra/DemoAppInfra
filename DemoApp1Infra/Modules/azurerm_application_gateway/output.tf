output "backend_pool_id" {
  value = one([
    for pool in azurerm_application_gateway.network.backend_address_pool :
    pool.id
    if pool.name == var.backend_address_pool_name
  ])
}
