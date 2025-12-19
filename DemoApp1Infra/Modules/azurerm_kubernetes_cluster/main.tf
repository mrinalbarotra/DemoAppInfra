resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = var.aks
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }
  identity {
    type = each.value.identity.type
  }
  tags = each.value.tags

}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks[*].kube_config_raw
  sensitive = true

  #  When Azure finishes deployment, it returns (via API):
  # client certificate
  # client key
  # CA certificate
  # cluster admin user credentials
  # kubeconfig YAML
  # Terraform stores this under:
  # azurerm_kubernetes_cluster.<name>.kube_config : structured formate
  # azurerm_kubernetes_cluster.<name>.kube_config_raw  : single YAML file
}
# default_node_pool {
#   name       = "default"
#   node_count = 1
#   vm_size    = "Standard_D2_v2"
# }

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     Environment = "Production"
#   }
# }

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.aks[*].kube_config[0].client_certificate
#   sensitive = true
# }
