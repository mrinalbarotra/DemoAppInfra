output "public_ip_id" {
  value = azurerm_public_ip.pip.id
}


# output "public_ip_ids" {
#   description = "Map of Public IP addresses"
#   value = {
#     for k, v in azurerm_public_ip.pip :
#     k => v.ip_address
#   }
# }

# output "public_ip_ids" {
#   value = {
#     for k, v in azurerm_public_ip.pip :
#     k => v.id
#   }
# }