terraform {
  backend "azurerm" {
    resource_group_name  = "Demo_Pipline1_rg"
    storage_account_name = "backendtfstate"
    container_name       = "tfstate"
    key                  = "Prod/terraform.tfstate"
  }
}
