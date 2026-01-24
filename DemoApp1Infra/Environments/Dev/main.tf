terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.0"
    }
  }
}
# plugin "azurerm" {
#   enabled = true
#   version = "0.26.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
# }


module "rgs" {
  source = "../../Modules/azurerm_resource_group"
  rgs    = var.rgs
  tags   = local.common_tags

}

module "vnets" {
  depends_on = [module.rgs]
  source     = "../../Modules/azurerm_virtual_network"
  vnets      = var.vnets
  tags       = local.common_tags
}

module "subnets" {
  depends_on = [module.rgs, module.vnets]
  source     = "../../Modules/azurerm_subnet"
  subnets    = var.subnets
}

module "nsgs" {
  depends_on = [module.rgs]
  source     = "../../Modules/azurerm_nsg"
  nsgs       = var.nsgs
  tags       = local.common_tags

}

module "subnet_nsg_assoc" {
  depends_on = [module.nsgs, module.subnets]
  source     = "../../Modules/azurerm_subnet_nsg_association"

  nsgtosubnets = {
    subnet1_assoc = {
      subnet_id                 = module.subnets.subnet_ids["subnet1"]
      network_security_group_id = module.nsgs.nsg_ids["nsg1"]
    }

    subnet2_assoc = {
      subnet_id                 = module.subnets.subnet_ids["subnet2"]
      network_security_group_id = module.nsgs.nsg_ids["nsg1"]
    }
  }
}

module "vmss" {
  source   = "../../Modules/azurerm_linux_vmss"
  for_each = var.vmss

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku       = each.value.sku
  instances = each.value.instances

  subnet_id = module.subnets.subnet_ids[each.value.subnet_key]
  appgw_backend_pool_id = (
    each.value.role == "frontend"
    ? module.app_gws["app_gw1"].backend_pool_id
    : null
  )
  admin_username = each.value.admin_username

  admin_ssh_key = {
    username   = each.value.admin_ssh_key.username
    public_key = data.azurerm_key_vault_secret.vmss_ssh_pubkey.value
  }

  os_disk = each.value.os_disk

  source_image_reference = each.value.source_image_reference

  custom_data = try(each.value.custom_data, null)

  tags = local.common_tags
}


# module "vms" {
#   depends_on = [module.rgs, module.subnets, ]
#   source     = "../../Modules/azurerm_virtual_machine"
#   vms        = local.vms
#   tags       = local.common_tags

# }


module "acrs" {
  depends_on          = [module.rgs]
  source              = "../../Modules/azurerm_acr"
  for_each            = var.acrs
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  # georeplications_location = each.value.georeplications_location
  # zone_redundancy_enabled  = each.value.zone_redundancy_enabled
  tags = local.common_tags
}

module "mssqlservers" {
  depends_on   = [module.rgs]
  source       = "../../Modules/azurerm_mssqlserver"
  mssqlservers = var.mssqlservers
  tags         = local.common_tags
}

module "mssqldatabase" {
  depends_on     = [module.rgs, module.mssqlservers]
  source         = "../../Modules/azurerm_mssql_database"
  mssqldatabases = var.mssqldatabases
  server_id      = module.mssqlservers.server_ids["sql1"]
  tags           = local.common_tags
}

module "pip" {
  depends_on          = [module.rgs]
  for_each            = var.pips
  source              = "../../Modules/azurerm_pip"
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku

  tags = local.common_tags

}

module "bastion" {
  depends_on           = [module.rgs, module.subnets, module.pip]
  source               = "../../Modules/azurern_bastion_host"
  name                 = "dev-demoapp1-centralindia-bastionhost1"
  resource_group_name  = "dev-demoapp1-centralindia-rg1"
  location             = "centralindia"
  ipconfigname         = "bastionipconfig"
  subnet_id            = module.subnets.subnet_ids["subnetbastion"]
  public_ip_address_id = module.pip["pip2"].public_ip_id #module.pip.public_ip_ids["pip2"]
  tags                 = local.common_tags

}

# module "sas" {
#   depends_on = [module.rgs]
#   source     = "../../Modules/azurer../m_storage_account"
#   stgs       = var.stgs
# }

module "kvs" {
  depends_on                 = [module.rgs]
  source                     = "../../Modules/azurerm_key_vault"
  for_each                   = var.kvs
  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = each.value.tenant_id
  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled
  sku_name                   = each.value.sku_name
  access_policy              = each.value.access_policy

  #   tenant_id           = each.value.tenant_id
  #   object_id           = each.value.object_id
  #   key_permissions     = each.value.key_permissions
  #   secret_permissions  = each.value.secret_permissions
  #   storage_permissions = each.value.storage_permissions
  # }

  tags = local.common_tags

}

module "app_gws" {
  depends_on          = [module.rgs, module.subnets, module.pip]
  source              = "../../Modules/azurerm_application_gateway"
  for_each            = var.app_gws
  app_gw_name         = each.value.app_gw_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  sku_name     = each.value.sku_name
  sku_tier     = each.value.sku_tier
  sku_capacity = each.value.sku_capacity

  gw_ip_config_name      = each.value.gw_ip_config_name
  gw_ip_config_subnet_id = module.subnets.subnet_ids["subnet3"]

  frontend_port_name = each.value.frontend_port_name
  frontend_port_port = each.value.frontend_port_port

  frontend_ip_config_name                 = each.value.frontend_ip_config_name
  frontend_ip_config_public_ip_address_id = module.pip["pip1"].public_ip_id

  backend_address_pool_name = each.value.backend_address_pool_name

  backend_http_settings_name                  = each.value.backend_http_settings_name
  backend_http_settings_cookie_based_affinity = each.value.backend_http_settings_cookie_based_affinity
  backend_http_settings_port                  = each.value.backend_http_settings_port
  backend_http_settings_protocol              = each.value.backend_http_settings_protocol
  backend_http_settings_request_timeout       = each.value.backend_http_settings_request_timeout

  http_listener_name     = each.value.http_listener_name
  http_listener_protocol = each.value.http_listener_protocol

  request_routing_rule_name      = each.value.request_routing_rule_name
  request_routing_rule_priority  = each.value.request_routing_rule_priority
  request_routing_rule_rule_type = each.value.request_routing_rule_rule_type

  tags = local.common_tags
}

module "ilbs" {
  depends_on          = [module.rgs, module.subnets]
  source              = "../../Modules/azurerm_ilb"
  for_each            = var.ilbs
  lb_name             = each.value.lb_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku


  # frontend_ip_config_name = each.value.frontend_ip_config_name
  # backend_pool_name       = each.value.backend_pool_name
  subnet_id = module.subnets.subnet_ids[each.value.subnet_key]

  # rule_name         = each.value.rule_name
  rule_protocol = each.value.rule_protocol
  frontend_port = each.value.frontend_port
  backend_port  = each.value.backend_port

  tags = local.common_tags
}



