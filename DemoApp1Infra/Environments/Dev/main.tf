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
  subnet_id            = module.subnets.subnet_ids["subnet2"]
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

