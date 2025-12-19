variable "aks" {
    description = "Map of Kubernetes cluster to be created"
    type = map(object({
      name = string
      location = string
      resource_group_name = string
      default_node_pool = object({
        name = string
        node_count = number
        vm_size = string
      })

      identity = object({
        type = string
      })
      
      tags = map(string)

    }))
}