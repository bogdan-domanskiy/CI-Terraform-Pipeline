provider "azurerm" {
  version = "=2.31.1"
  features {}
}

# locals{
#   statefile = "${terraform.workspace}.terraform.tfstate"
# }




resource "azurerm_resource_group" "DomanRG" {
  name     = "${var.name}RG"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "DomanSA" {
  name                     = lower("${var.name}sa")
  resource_group_name      = azurerm_resource_group.DomanRG.name
  location                 = azurerm_resource_group.DomanRG.location
  account_replication_type = var.SAReplicType
  account_tier             = var.SA-tier
  account_kind             = var.SA_kind
  min_tls_version          = var.TLS
  tags                     = var.tags

  depends_on = [
    azurerm_resource_group.DomanRG,
  ]
}

output "storage_account_tier" {
  value = azurerm_storage_account.DomanSA.account_tier
}
output "storage_account_kind" {
  value = azurerm_storage_account.DomanSA.account_kind
}
output "access_tier" {
  value = azurerm_storage_account.DomanSA.access_tier
}

data "azurerm_client_config" "current" {}

data "azuread_user" "MyUser" {
  user_principal_name = var.principal_name
}


# locals{
#   ObjectID = [
#     "${data.azurerm_client_config.current.object_id}",
#     "${data.azuread_user.MyUser.object_id}",
#   ]
# }

resource "azurerm_key_vault" "KeyVault" {
  name                = "${var.name}-kv"
  resource_group_name = azurerm_resource_group.DomanRG.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  location            = var.location
  tags                = var.tags
  sku_name            = "standard"

  depends_on = [
    azurerm_storage_account.DomanSA,
  ]

  dynamic "access_policy" {
    for_each = [data.azurerm_client_config.current.object_id, data.azuread_user.MyUser.object_id, ]
    content {
      object_id          = access_policy.value
      tenant_id          = data.azurerm_client_config.current.tenant_id
      secret_permissions = var.permissions
    }
  }

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azuread_user.MyUser.object_id
    secret_permissions = var.permissions
  }
}

# locals{
#   type = string
#   Objects = [for id in local.ObjectID : lower(id)]
# }

# resource "azurerm_key_vault_access_policy" "AccessForApp" {
#   key_vault_id = azurerm_key_vault.KeyVault.id
#   tenant_id = data.azurerm_client_config.current.tenant_id
#
#   # object_id = local.Objects
#   secret_permissions = var.permissions
# }

# output "connection-string" {
#   value                    = azurerm_storage_account.DomanSA.primary_connection_string
# }

resource "azurerm_key_vault_secret" "Secret" {
  name         = "${var.name}-secret"
  key_vault_id = azurerm_key_vault.KeyVault.id
  value        = azurerm_storage_account.DomanSA.primary_connection_string
  #value                    = connection-string.value
  depends_on = [
    azurerm_key_vault.KeyVault,
  ]

}

resource "azurerm_container_group" "Container_instance" {
  name                = "${var.name}-continst"
  location            = azurerm_resource_group.DomanRG.location
  resource_group_name = azurerm_resource_group.DomanRG.name
  ip_address_type     = "Public"
  dns_name_label      = lower("${var.name}cg-label")
  os_type             = "Linux"
  tags                = var.tags

  container {
    name   = var.container
    image  = "${var.container}:8.5-community"
    cpu    = "1"
    memory = "2"

    # image_registry_credential{
    #   username = lower(var.name)
    #   password = var.user_password
    #   server = "${var.name}cg-label.${var.domain}"
    # }


    # readiness_probe{
    #   http_get{
    #     path = lower("${var.name}cg-label.${var.domain}")
    #     port = 9000
    #     scheme = "Http"
    #   }
    #   initial_delay_seconds = 60
    #   period_seconds = 10
    #   failure_threshold = 3
    #   success_threshold = 2
    #   timeout_seconds = 8
    # }

    volume {
      name       = "${var.container}-storage"
      mount_path = "/opt/sonarqube/data"
      read_only  = false
      share_name = var.share_file
      storage_account_name = var.storage_name
      storage_account_key   = var.sa_key
    }

    ports {
      port     = 9000
      protocol = var.protocol
    }

  }
}
