# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  consul_secrets = {
    for parameter, value in jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.consul.secret_string)) :
  parameter => value if try(value.accessor_id, null) != null && parameter != "acl_token" }
  files = fileset("${path.module}/policies", "*.hcl")
  secret_policy_association = {
    for secret_key, secret in local.consul_secrets : secret_key => {
      accessor_id = secret.accessor_id
      data        = secret.data
      name        = secret.name
      description = secret.description
      policy      = one(compact([for file in local.files : strcontains(secret.name, trimsuffix(file, "-default.hcl")) ? file : null]))
    } if length(compact([for file in local.files : strcontains(secret.name, trimsuffix(file, "-default.hcl")) ? file : null])) > 0
  }
}

data "aws_secretsmanager_secret_version" "consul" {
  secret_id = var.consul_secrets_arn
}

resource "terracurl_request" "tokens" {
  for_each     = local.consul_secrets
  name         = each.value.name
  url          = "https://${var.consul_url}/v1/acl/token"
  method       = "PUT"
  request_body = <<EOF
{
  "AccessorID": "${each.value.accessor_id}",
  "SecretID": "${each.value.data}",
  "Description": "${each.value.description}"
}
EOF
  headers = {
    X-Consul-Token = var.consul_token
  }

  response_codes = [
    200,
  ]

  cert_file       = var.consul_cert_file
  key_file        = var.consul_key_file
  ca_cert_file    = var.consul_ca_file
  skip_tls_verify = var.skip_tls_verify

  destroy_url    = "https://${var.consul_url}/v1/acl/token/${each.value.accessor_id}"
  destroy_method = "DELETE"

  destroy_headers = {
    X-Consul-Token = var.consul_token
  }

  destroy_response_codes = [
    204,
    200
  ]

  destroy_cert_file       = var.consul_cert_file
  destroy_key_file        = var.consul_key_file
  destroy_ca_cert_file    = var.consul_ca_file
  destroy_skip_tls_verify = var.skip_tls_verify
}

resource "consul_acl_policy" "policies" {
  depends_on  = [terracurl_request.tokens]
  for_each    = local.secret_policy_association
  name        = "${each.value.name}-policy"
  datacenters = var.consul_datacenters
  rules       = file("${path.module}/policies/${each.value.policy}")
}

resource "consul_acl_token_policy_attachment" "policy_attach" {
  for_each = local.secret_policy_association
  token_id = each.value.accessor_id
  policy   = consul_acl_policy.policies[each.key].name
}

