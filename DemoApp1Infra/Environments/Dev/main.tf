terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
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

module "vms" {
  depends_on = [module.rgs, module.subnets, ]
  source     = "../../Modules/azurerm_virtual_machine"
  vms        = local.vms
  tags       = local.common_tags

}


# module "acrs" {
#   depends_on = [ module.rgs ]
#   source = "../../Modules/azurerm_acr"
#   acrs = var.acrs
# }

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
  depends_on = [module.rgs]
  source     = "../../Modules/azurerm_pip"
  pips       = var.pips
  tags       = local.common_tags

}

# module "sas" {
#   depends_on = [module.rgs]
#   source     = "../../Modules/azurer../m_storage_account"
#   stgs       = var.stgs
# }

# module "kvs" {
#   depends_on = [module.rgs]
#   source     = "../../Modules/azurerm_key_vault"
#   kvs        = var.kvs
#   tenant_id = data.azurerm_client_config.current.tenant_id
# }

