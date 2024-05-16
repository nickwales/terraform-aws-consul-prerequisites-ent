# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  # ! Temp until Replicated is depricated
  product = var.product == "tfefdo" ? "tfe" : var.product

  # * Provided secrets map with any secrets that are null removed
  product_secrets = {
    for parameter, value in local.provided_secrets[local.product] : parameter => value if value != null
  }

  license_merge = merge(
    local.product_secrets,
    {
      for parameter, value in local.product_secrets :
      parameter => {
        name        = value.name,
        description = value.description,
        data        = try(value.data, null) != null ? value.data : (try(file(value.path), null))
      }
    }
  )

  provided_secrets = {
    for parameter, value in var.secretsmanager_secrets : parameter => {
      for inner_key, inner_value in value : inner_key => inner_value if inner_value != null
    } if value != null
  }

  # * Optional secrets map with all entries that are null stripped
  optional_secrets = {
    for parameter, value in var.optional_secrets : parameter => value if value != null
  }

  # * Filters the input map based on the provided product and if the `generate` flag is true and the `data` has no value
  product_generated = {
    for parameter, value in local.product_secrets : parameter => value if try(value.generate, false) && try(value.data, null) == null
  }


  # * Checks if the product is `consul` if it is then it only supplies the secrets at the first level that do not contain `consul` as the prefix. If not then we just use the original local
  # * Merges the optional secrets map into the first map if any were supplied.
  # * If the product is `consul` then it creates a submap called `consul` and then loops through and merges all the dynamically generated tokens for the
  # * gossip_key as well as the accessor_id and the tokens. We need the accessor ID for API calls to Consul to store the SecretID because it's not in the provider
  # * If the product isn't Consul then we are going to merge the generated passwords for TFE (if there are any)
  # * This is so we can use 1 secret for the entire application and reference the json body while maintaining separation of licenses and certs
  # * Limiting this to just Consul as it has the most secret entries but could change depending on product requirements.
  updated_secrets = local.product != "consul" ? merge(
    local.provided_secrets,
    local.optional_secrets,
    {
      "${local.product}" = merge(local.license_merge, {
        for parameter, value in local.product_generated :
        parameter => {
          name        = value.name
          description = value.description
          data = coalesce(
            value.data,
            contains(["db_password", "enc_password", "console_password"], parameter) ? try(random_password.rpw[parameter].result, null) : null,
          )
      } })
    }) : merge(
    local.provided_secrets,
    local.optional_secrets,
    {
      "${local.product}" = merge(local.license_merge, {
        for parameter, value in local.product_generated :
        parameter => {
          name        = value.name
          description = value.description
          data = coalesce(
            value.data,
            parameter == "gossip_key" ? try(random_id.gossip_gen[0].b64_std, null) : null,
            parameter != "gossip_key" ? try(random_uuid.token_gen[parameter].result, null) : null
          )
          accessor_id = try(random_uuid.accessor_gen[parameter].result, null)
        } if value != null
      })
  })
}

resource "random_password" "rpw" {
  for_each         = contains(["tfe", "tfefdo", "boundary"], local.product) ? local.product_generated : {}
  length           = 16
  special          = true
  min_special      = 1
  min_numeric      = 1
  override_special = "!#%&*()-_=+[]{}<>:?"
}

resource "random_id" "gossip_gen" {
  count       = try(local.product_generated.gossip_key.generate, false) ? 1 : 0
  byte_length = 32
}

resource "random_uuid" "token_gen" {
  for_each = local.product == "consul" ? { for parameter, value in local.product_generated : parameter => value if !strcontains(parameter, "gossip_key") } : {}
}

resource "random_uuid" "accessor_gen" {
  for_each = local.product == "consul" ? { for parameter, value in local.product_generated : parameter => value if !strcontains(parameter, "gossip_key") } : {}
}

resource "aws_secretsmanager_secret" "secrets" {
  for_each    = local.updated_secrets
  name        = try("${var.friendly_name_prefix}-${each.value.name}", "${var.friendly_name_prefix}-${each.key}")
  description = try(each.value.description, "Secrets for ${local.product}")
  tags        = var.common_tags
}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each      = local.updated_secrets
  secret_binary = try(filebase64(each.value.path), null)
  secret_string = strcontains(each.key, local.product) ? try(jsonencode(local.updated_secrets[local.product]), null) : try(each.value.data, null)
  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
}
