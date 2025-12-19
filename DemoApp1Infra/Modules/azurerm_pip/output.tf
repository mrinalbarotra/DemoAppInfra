output "public_ip_ids" {
  description = "Map of Public IP addresses"
  value = {
    for k, v in azurerm_public_ip.pip :
    k => v.ip_address
  }
}