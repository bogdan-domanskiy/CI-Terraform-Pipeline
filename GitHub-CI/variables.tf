variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "SAReplicType" {
  type = string
}

variable "SA-tier" {
  type = string
}

variable "KV-tier" {
  type = string
}

variable "permissions" {
  type = list
}

variable "SA_kind" {
  type = string
}

variable "TLS" {
  type = string
}

variable "container" {
  type = string
}

variable "protocol" {
  type = string
}

variable "principal_name" {
  type = string
  default = null
}

# variable "user_password"{
#   type = string
#   default = null
# }

variable "domain" {
  type = string
}

variable "share_file" {
  type = string
}


variable "storage_name" {
  type = string
}

variable "sa_key"{
  type = string
  default = null
}
# variable "subscription" {
#   type = string
# }

# variable "ObjectID"{
#   type = list(string)
#   default = null
# }
