# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "consul_acl_policies" {
  value = { for parameter, value in consul_acl_policy.policies :
    parameter => {
      name        = value.name
      namespace   = value.namespace
      id          = value.id
      datacenters = value.datacenters
      partition   = value.partition
      description = value.description
    }
  }
  description = "Map of the ACL Policies that were created as a result of the run"
}

output "consul_acl_policy_attachment" {
  value       = consul_acl_token_policy_attachment.policy_attach
  description = "Map of the policies that were attached to each accessor id"
}