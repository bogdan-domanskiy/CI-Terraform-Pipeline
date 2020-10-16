location = "West Europe"

name = "DomanProd"

#variable "env"{
#  type =
#  default =
#}

#locals {
#  name = "${var.override_name != "" ? var.override_name : "${var.product}-{$var.env}"}""
#}

tags = {
  App         = "DomanApp-Prod"
  environment = "Prod"
  version     = "v2"
  source      = "terraform"
}

SAReplicType = "LRS"

SA-tier = "standard"

SA_kind = "Storage"

TLS = "TLS1_2"
