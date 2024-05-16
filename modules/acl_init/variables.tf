# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "consul_token" {
  description = "Consul token to use when making the API requests"
  type        = string
}

variable "consul_url" {
  description = "URL for the Consul Cluster to bootstrap the ACLs"
  type        = string
}

variable "consul_secrets_arn" {
  description = "ARN of the Secrets Manager Secret that contains the Consul tokens."
  type        = string
}

variable "skip_tls_verify" {
  description = "Boolean that when true, will skip the TLS verification for the API calls"
  type        = bool
  default     = false
}

variable "consul_ca_file" {
  description = "Path on disk to the ca certificate to use when making the API request (if skip_tls_verify is false)"
  type        = string
  default     = ""
}

variable "consul_cert_file" {
  description = "Path on disk to the public certificate to use when making the API request (if skip_tls_verify is false)"
  type        = string
  default     = ""
}

variable "consul_key_file" {
  description = "Path on disk to the private certificate to use when making the API request (if skip_tls_verify is false)"
  type        = string
  default     = ""
}

variable "consul_datacenters" {
  description = "Datacenters where the ACL Policy will be created"
  type        = list(string)
  default     = null
}
