terraform {
  backend "azurerm" {
    resource_group_name  = "DomanRG"
    storage_account_name = "remotestoragedoman"
    container_name       = "storage"
    key                  = "Terraform.tfstateenv:prod"

  }
}
