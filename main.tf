locals {
  merged_kms = {
    for k, v in var.s3_buckets :
    k => merge(v, {
      kms_key_arn = try(v.sse_s3_managed_key, false) ? "" : try(module.kms[0].kms_key_alias_arn, v.kms_key_arn)
    })
  }
  # Friendly name prefix with a random hex ID to ensure uniqueness
  friendly_name_prefix_rid = "${var.friendly_name_prefix}-${random_id.pre_req_rid.hex}"
}

resource "random_id" "pre_req_rid" {
  byte_length = 3
}

data "aws_region" "current" {}

module "networking" {
  source = "./modules/networking"
  count  = var.create_vpc ? 1 : 0

  vpc_cidr                           = var.vpc_cidr
  vpc_name                           = var.vpc_name
  public_subnets                     = var.public_subnets
  private_subnets                    = var.private_subnets
  friendly_name_prefix               = local.friendly_name_prefix_rid
  common_tags                        = var.common_tags
  vpc_enable_ssm                     = var.vpc_enable_ssm
  vpc_default_security_group_egress  = var.vpc_default_security_group_egress
  vpc_default_security_group_ingress = var.vpc_default_security_group_ingress
  vpc_option_flags                   = var.vpc_option_flags
  vpc_endpoint_flags                 = var.vpc_endpoint_flags
  product                            = var.product
}

module "ingress" {
  source = "./modules/ingress"
  count  = var.create_lb ? 1 : 0

  vpc_id                              = var.create_vpc ? try(module.networking[0].vpc_id, null) : var.vpc_id
  lb_subnet_ids                       = length(var.lb_subnet_ids) != 0 ? var.lb_subnet_ids : (var.create_vpc && !var.lb_internal ? try(module.networking[0].public_subnet_ids, null) : (var.create_vpc && var.lb_internal ? try(module.networking[0].private_subnet_ids, null) : var.private_subnet_ids))
  lb_name                             = var.lb_name
  lb_internal                         = var.lb_internal
  lb_security_group_ids               = var.lb_security_group_ids
  lb_certificate_arn                  = var.lb_certificate_arn
  lb_type                             = var.lb_type
  create_lb_certificate               = var.create_lb_certificate
  create_lb_security_groups           = var.create_lb_security_groups
  lb_sg_rules_details                 = var.lb_sg_rules_details
  lb_listener_details                 = var.lb_listener_details
  lb_target_groups                    = var.lb_target_groups
  route53_zone_name                   = var.route53_zone_name
  route53_failover_record             = var.route53_failover_record
  route53_record_health_check_enabled = var.route53_record_health_check_enabled
  route53_private_zone                = var.route53_private_zone
  common_tags                         = var.common_tags
  friendly_name_prefix                = local.friendly_name_prefix_rid
}

module "kms" {
  source = "./modules/kms"
  count  = var.create_kms ? 1 : 0

  kms_default_policy_enabled = var.kms_default_policy_enabled
  kms_key_usage              = var.kms_key_usage
  kms_key_deletion_window    = var.kms_key_deletion_window
  kms_key_name               = var.kms_key_name
  kms_key_description        = var.kms_key_description
  kms_key_users_or_roles     = var.kms_key_users_or_roles
  kms_allow_asg_to_cmk       = var.kms_allow_asg_to_cmk
  kms_asg_role_arns          = var.create_iam_resources ? try([module.iam[0].asg_role_arn], []) : var.kms_asg_role_arns
  friendly_name_prefix       = local.friendly_name_prefix_rid
  common_tags                = var.common_tags
  product                    = var.product
}

module "iam" {
  source = "./modules/iam"
  count  = var.create_iam_resources ? 1 : 0

  friendly_name_prefix               = local.friendly_name_prefix_rid
  create_asg_service_iam_role        = var.create_asg_service_iam_role
  asg_service_iam_role_custom_suffix = var.asg_service_iam_role_custom_suffix
  product                            = var.product
  iam_resources = {
    bucket_arns            = var.create_s3_buckets ? try(module.s3[0].s3_bucket_arn_list, null) : var.iam_resources.bucket_arns
    kms_key_arns           = var.create_kms ? try(concat([module.kms[0].kms_key_alias_arn], [module.kms[0].kms_key_arn]), null) : var.iam_resources.kms_key_arns
    secret_manager_arns    = var.create_secrets ? try(module.secrets_manager[0].secret_arn_list, null) : var.iam_resources.secrets_manager_arns
    log_group_arn          = var.create_log_group ? try(aws_cloudwatch_log_group.consul[0].arn, null) : var.iam_resources.log_group_arn
    log_forwarding_enabled = var.iam_resources.log_forwarding_enabled
    ssm_enable             = var.iam_resources.ssm_enable ? var.iam_resources.ssm_enable : (var.vpc_enable_ssm ? true : false)
    role_name              = var.iam_resources.role_name
    policy_name            = var.iam_resources.policy_name
  }
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  count  = var.create_secrets ? 1 : 0

  secretsmanager_secrets = var.secretsmanager_secrets
  optional_secrets       = var.optional_secrets
  friendly_name_prefix   = local.friendly_name_prefix_rid
  common_tags            = var.common_tags
  product                = var.product
}

module "s3" {
  source = "./modules/s3"
  count  = var.create_s3_buckets ? 1 : 0

  s3_buckets           = local.merged_kms
  friendly_name_prefix = local.friendly_name_prefix_rid
}

resource "aws_cloudwatch_log_group" "consul" {
  count             = var.create_log_group ? 1 : 0
  name              = "${local.friendly_name_prefix_rid}-${var.log_group_name}"
  retention_in_days = var.log_group_retention_days
  kms_key_id        = var.create_kms ? module.kms[0].kms_key_alias_arn : var.cloudwatch_kms_key_arn

  tags = var.common_tags
}

module "sg" {
  source               = "./modules/sg"
  count                = var.create_security_groups ? 1 : 0
  security_group_rules = var.security_group_rules
  friendly_name_prefix = local.friendly_name_prefix_rid
  common_tags          = var.common_tags
  product              = var.product
  vpc_id               = var.create_vpc ? try(module.networking[0].vpc_id, null) : var.vpc_id
}

resource "aws_key_pair" "ssh" {
  count = var.create_ssh_keypair ? 1 : 0

  key_name   = "${local.friendly_name_prefix_rid}-${var.ssh_keypair_name}"
  public_key = var.ssh_public_key
  tags       = var.common_tags
}

module "route53_resolver" {
  count                = var.create_lb && var.lb_internal && var.route53_resolver_pool.enabled ? 1 : 0
  source               = "./modules/route53_resolver"
  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags
  product              = var.product
  vpc_id               = var.create_vpc ? try(module.networking[0].vpc_id, null) : var.vpc_id
  route53_resolver_pool = {
    enabled       = var.route53_resolver_pool.enabled
    consul_domain = var.route53_resolver_pool.consul_domain
    lb_arn_suffix = module.ingress[0].lb_arn_suffix
  }
  private_subnet_ids = var.create_vpc ? module.networking[0].private_subnet_ids : var.private_subnet_ids
}
