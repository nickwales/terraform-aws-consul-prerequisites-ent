# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "consul_acl_policies" {
  value       = module.acl_init.consul_acl_policies
  description = "Map of the ACL Policies that were created as a result of the run"
}

output "consul_acl_policy_attachment" {
  value       = module.acl_init.consul_acl_policy_attachment
  description = "Map of the policies that were attached to each accessor id"
}