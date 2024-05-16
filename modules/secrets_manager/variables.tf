# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "product" {
  type        = string
  description = "Name of the HashiCorp product that will consume this service (tfe, tfefdo, vault, consul, nomad, boundary)"
  validation {
    condition     = contains(["tfe", "tfefdo", "vault", "consul", "boundary", "nomad"], var.product)
    error_message = "`var.product` must be \"tfe\", \"tfefdo\", \"vault\", \"consul\", \"nomad\", or \"boundary\"."
  }
}

variable "secretsmanager_secrets" {
  type = object({
    consul = optional(object({
      license = optional(object({
        name        = optional(string, "consul-license")
        description = optional(string, "Consul license")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
      acl_token = optional(object({
        name        = optional(string, "consul-acl-token")
        description = optional(string, "Consul default ACL token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      agent_token = optional(object({
        name        = optional(string, "consul-agent-token")
        description = optional(string, "Consul agent token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      gossip_key = optional(object({
        name        = optional(string, "consul-gossip-key")
        description = optional(string, "Consul Gossip encryption key")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      snapshot_token = optional(object({
        name        = optional(string, "consul-snapshot-token")
        description = optional(string, "Consul Snapshot token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      replication_token = optional(object({
        name        = optional(string, "consul-replication-token")
        description = optional(string, "Consul Replication token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      mesh_gw_token = optional(object({
        name        = optional(string, "consul-mesh-gw-token")
        description = optional(string, "Consul Mesh Gateway token")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      ingress_gw_token = optional(object({
        name        = optional(string, "consul-ingress-gw-token")
        description = optional(string, "Consul gossip encryption key")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      terminating_gw_token = optional(object({
        name        = optional(string, "consul-terminating-gw-token")
        description = optional(string, "Consul Terminating Gateway key")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
    }))
    replicated_license = optional(object({
      name        = optional(string, "tfe-replicated-license")
      path        = optional(string, null)
      description = optional(string, "license")
      data        = optional(string, null)
    }))
    tfe = optional(object({
      license = optional(object({
        name        = optional(string, "tfe-license")
        description = optional(string, "License for TFE FDO")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
      enc_password = optional(object({
        name        = optional(string, "enc-password")
        description = optional(string, "Encryption password used in the TFE installation")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      console_password = optional(object({
        name        = optional(string, "console-password")
        description = optional(string, "Console password used in the TFE installation")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
    }))
    boundary = optional(object({
      license = optional(object({
        name        = optional(string, "boundary-license")
        description = optional(string, "License for Boundary Enterprise")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
      db_username = optional(object({
        name        = optional(string, "db-username")
        description = optional(string, "Username for the boundary database")
        data        = optional(string, "boundary")
      }))
      db_password = optional(object({
        name        = optional(string, "db-password")
        description = optional(string, "Password for the boundary database")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      hcp_username = optional(object({
        name        = optional(string, "hcp-username")
        description = optional(string, "HCP Boundary Username for Worker Registration")
        data        = optional(string, "boundary")
      }))
      hcp_password = optional(object({
        name        = optional(string, "hcp-password")
        description = optional(string, "HCP Boundary Password for Worker Registration")
        data        = optional(string, null)
      }))
    }))
    vault = optional(object({
      license = optional(object({
        name        = optional(string, "vault-license")
        description = optional(string, "Vault License")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
    }))
    ca_certificate_bundle = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO CA certificate bundle")
      data        = optional(string, null)
    }))
    cert_pem_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO PEM-encoded TLS certificate")
      data        = optional(string, null)
    }))
    cert_pem_private_key_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO PEM-encoded TLS private key")
      data        = optional(string, null)
    }))
  })
  description = "Object Map that contains various secrets that will be created and stored in AWS Secrets Manager."
  default     = {}
}

variable "optional_secrets" {
  type        = map(any)
  default     = {}
  description = <<DESC
  Optional variable that when supplied will be merged with the `secretsmanager_secrets` map. These secrets need to have the following specification:
  optional_secrets = {
    secret_1 = {
      name = "supesecret"
      description = "it's my secret that is important"
      path = "path to file if you are using one"
      data = "string data if you are supplying it"
    }
    secret_2 = {
      name = "supesecret2"
      description = "it's my secret that is also important probably"
      path = "path to file if you are using one"
      data = "string data if you are supplying it"
    }
  }
  DESC
}