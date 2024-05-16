# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "kms_key_arn" {
  value       = !var.create_multi_region_replica_key ? aws_kms_key.key[0].arn : aws_kms_replica_key.key[0].arn
  description = "The KMS key used to encrypt data."
}

output "kms_key_id" {
  value       = !var.create_multi_region_replica_key ? aws_kms_key.key[0].key_id : aws_kms_replica_key.key[0].key_id
  description = "The KMS Key ID"
}

output "kms_key_alias" {
  value       = aws_kms_alias.alias.name
  description = "The KMS Key Alias"
}

output "kms_key_alias_arn" {
  value       = aws_kms_alias.alias.arn
  description = "The KMS Key Alias arn"
}
