# # Copyright (c) HashiCorp, Inc.
# # SPDX-License-Identifier: MPL-2.0

#------------------------------------------------------------------------------
# General Outputs
#------------------------------------------------------------------------------

output "replicated_license_secret_arn" {
  value       = try(aws_secretsmanager_secret.secrets["replicated_license"].arn, null)
  description = "AWS Secrets Manager `replicated` secret ARN."
}

output "ca_certificate_bundle_secret_arn" {
  value       = try(aws_secretsmanager_secret.secrets["ca_certificate_bundle"].arn, null)
  description = "AWS Secrets Manager BYO CA certificate bundle ARN."
}

output "cert_pem_secret_arn" {
  value       = try(aws_secretsmanager_secret.secrets["cert_pem_secret"].arn, null)
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "cert_pem_private_key_secret_arn" {
  value       = try(aws_secretsmanager_secret.secrets["cert_pem_private_key_secret"].arn, null)
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "secret_arn_list" {
  value       = [for secret in aws_secretsmanager_secret.secrets : secret.arn]
  description = "A list of AWS Secrets Manager ARNs produced by the module."
}

output "optional_secrets" {
  value       = length(var.optional_secrets) >= 1 ? { for k, v in local.optional_secrets : k => aws_secretsmanager_secret.secrets[k].arn } : {}
  description = "A map of optional secrets that have been created if they were supplied during the time of execution. Output is a single map where the key of the map for the secret is the key and the ARN is the value."
}
#------------------------------------------------------------------------------
# TFE Outputs
#------------------------------------------------------------------------------

output "tfe_secrets_arn" {
  value       = try(aws_secretsmanager_secret.secrets["tfe"].arn, null)
  description = "AWS Secrets Manager TFE secrets ARN."
}

#------------------------------------------------------------------------------
# Consul Outputs
#------------------------------------------------------------------------------

output "consul_secrets_arn" {
  value       = try(aws_secretsmanager_secret.secrets["consul"].arn, null)
  description = "AWS Secrets Manager `consul` secrets ARN."
}

#------------------------------------------------------------------------------
# Vault Outputs
#------------------------------------------------------------------------------

output "vault_secrets_arn" {
  value       = try(aws_secretsmanager_secret.secrets["vault"].arn, null)
  description = "AWS Secrets Manager `vault` secrets ARN."
}

#------------------------------------------------------------------------------
# Boundary Outputs
#------------------------------------------------------------------------------

output "boundary_secrets_arn" {
  value       = try(aws_secretsmanager_secret.secrets["boundary"].arn, null)
  description = "AWS Secrets Manager `boundary` secrets ARN."
}

