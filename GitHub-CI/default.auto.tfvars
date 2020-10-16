location = "West Europe"

name = "Doman"

#variable "env"{
#  type =
#  default =
#}

#locals {
#  name = "${var.override_name != "" ? var.override_name : "${var.product}-{$var.env}"}""
#}

tags = {
  App         = "DomanApp"
  environment = "test"
  version     = "v2"
  source      = "terraform"
}

SAReplicType = "LRS"

SA-tier = "standard"

SA_kind = "Storage"

TLS = "TLS1_2"

KV-tier = "standard"

permissions = [
  "get",
  "backup",
  "delete",
  "list",
  "purge",
  "recover",
  "restore",
  "set",
]

container = "sonarqube"

protocol = "TCP"

domain = "westeurope.azurecontainer.io"

share_file = "sonarqube-share"

storage_name = "remotestoragedoman"
