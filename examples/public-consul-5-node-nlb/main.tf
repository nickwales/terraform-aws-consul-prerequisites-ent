module "pre_req_primary" {
  source = "../../"
  #------------------------------------------------------------------------------
  # General
  #------------------------------------------------------------------------------
  common_tags          = var.common_tags
  friendly_name_prefix = var.friendly_name_prefix

  #------------------------------------------------------------------------------
  # VPC
  #------------------------------------------------------------------------------
  create_vpc     = true
  vpc_enable_ssm = true

  #------------------------------------------------------------------------------
  # Secrets Manager
  #------------------------------------------------------------------------------
  create_secrets         = true
  secretsmanager_secrets = var.secretsmanager_secrets

  #------------------------------------------------------------------------------
  # KMS
  #------------------------------------------------------------------------------
  create_kms = true

  #------------------------------------------------------------------------------
  # IAM
  #------------------------------------------------------------------------------
  create_iam_resources = true
  iam_resources        = var.iam_resources

  #------------------------------------------------------------------------------
  # S3
  #------------------------------------------------------------------------------
  create_s3_buckets = true
  s3_buckets        = var.s3_buckets

  #------------------------------------------------------------------------------
  # Logging
  #------------------------------------------------------------------------------
  create_log_group = true

  #------------------------------------------------------------------------------
  # Keypair
  #------------------------------------------------------------------------------
  create_ssh_keypair = true
  ssh_public_key     = var.ssh_public_key

  #------------------------------------------------------------------------------
  # Security Groups
  #------------------------------------------------------------------------------
  create_security_groups = true
  security_group_rules   = var.security_group_rules

  #------------------------------------------------------------------------------
  # Load Balancer
  #------------------------------------------------------------------------------
  create_lb                 = true
  create_lb_security_groups = false
  create_lb_certificate     = false
  lb_internal               = var.lb_internal
  lb_type                   = var.lb_type
  route53_zone_name         = var.route53_zone_name
  route53_failover_record   = var.route53_failover_record
  lb_target_groups          = var.lb_target_groups
  lb_listener_details       = var.lb_listener_details
  route53_resolver_pool     = var.route53_resolver_pool
}

#------------------------------------------------------------------------------
# Consul Server example
# This is only here for example purposes
# Uncomment the block below to provision a cluster
#------------------------------------------------------------------------------

# module "consul" {
#   source = "../../../terraform-aws-consul"
#   ssh_key_pair             = module.pre_req_primary.ssh_keypair_name
#   kms_key_arn              = module.pre_req_primary.kms_key_arn
#   iam_instance_profile_arn = module.pre_req_primary.iam_instance_profile_arn
#   asg_max_size             = 5
#   asg_instance_count       = 5
#   asg_hook_value           = module.pre_req_primary.asg_hook_value
#   lb_type                  = module.pre_req_primary.lb_type
#   ec2_subnet_ids           = module.pre_req_primary.private_subnet_ids
#   lb_tg_arns = [
#     module.pre_req_primary.lb_tg_arns_map.consul_api_tls,
#   ]
#   cloudwatch_log_group_name = module.pre_req_primary.cloudwatch_log_group_name
#   log_forwarding_enabled    = var.log_forwarding_enabled
#   friendly_name_prefix      = var.friendly_name_prefix
#   launch_template_sg_ids    = []
#   ca_bundle_secret_arn      = module.pre_req_primary.ca_certificate_bundle_secret_arn
#   cert_secret_arn           = module.pre_req_primary.cert_pem_secret_arn
#   private_key_secret_arn    = module.pre_req_primary.cert_pem_private_key_secret_arn
#   consul_secrets_arn        = module.pre_req_primary.consul_secrets_arn
#   common_tags               = var.common_tags
#   consul_agent = {
#     auto_reload_config = var.consul_server_agent.auto_reload_config
#     server             = var.consul_server_agent.server
#     ui                 = var.consul_server_agent.ui
#     join_environment   = var.consul_server_agent.join_environment
#     security_group_id  = module.pre_req_primary.server_security_group_id
#   }
#   snapshot_agent = {
#     enabled      = var.snapshot_agent.enabled
#     interval     = var.snapshot_agent.interval
#     retention    = var.snapshot_agent.retention
#     s3_bucket_id = module.pre_req_primary.s3_snapshot_bucket_name
#   }
#   environment_name       = var.consul_server_environment_name
#   consul_cluster_version = var.consul_server_cluster_version
#   route53_resolver_pool  = var.route53_resolver_pool
# }

# module "agent" {
#   depends_on                = [module.pre_req_primary]
#   source = "../../../terraform-aws-consul"
#   ssh_key_pair              = module.pre_req_primary.ssh_keypair_name
#   kms_key_arn               = module.pre_req_primary.kms_key_arn
#   iam_instance_profile_arn  = module.pre_req_primary.iam_instance_profile_arn
#   asg_max_size              = 1
#   asg_instance_count        = 1
#   asg_hook_value            = module.pre_req_primary.asg_hook_value
#   ec2_subnet_ids            = module.pre_req_primary.private_subnet_ids
#   cloudwatch_log_group_name = module.pre_req_primary.cloudwatch_log_group_name
#   friendly_name_prefix      = var.friendly_name_prefix
#   ca_bundle_secret_arn      = module.pre_req_primary.ca_certificate_bundle_secret_arn
#   cert_secret_arn           = module.pre_req_primary.cert_pem_secret_arn
#   private_key_secret_arn    = module.pre_req_primary.cert_pem_private_key_secret_arn
#   consul_secrets_arn        = module.pre_req_primary.consul_secrets_arn
#   common_tags               = var.common_tags
#   consul_agent = {
#     auto_reload_config = var.consul_agent.auto_reload_config
#     server             = var.consul_agent.server
#     ui                 = var.consul_agent.ui
#     join_environment   = var.consul_agent.join_environment
#     security_group_id  = module.pre_req_primary.server_security_group_id
#   }
#   environment_name       = var.consul_agent_environment_name
#   consul_cluster_version = var.consul_agent_cluster_version
# }

# module "tgw" {
#   depends_on                = [module.pre_req_primary]
#   source = "../../../terraform-aws-consul"
#   ssh_key_pair              = module.pre_req_primary.ssh_keypair_name
#   kms_key_arn               = module.pre_req_primary.kms_key_arn
#   iam_instance_profile_arn  = module.pre_req_primary.iam_instance_profile_arn
#   asg_max_size              = 1
#   asg_instance_count        = 1
#   asg_hook_value            = module.pre_req_primary.asg_hook_value
#   lb_type                   = module.pre_req_primary.lb_type
#   ec2_subnet_ids            = module.pre_req_primary.private_subnet_ids
#   cloudwatch_log_group_name = module.pre_req_primary.cloudwatch_log_group_name
#   friendly_name_prefix      = var.friendly_name_prefix
#   ca_bundle_secret_arn      = module.pre_req_primary.ca_certificate_bundle_secret_arn
#   cert_secret_arn           = module.pre_req_primary.cert_pem_secret_arn
#   private_key_secret_arn    = module.pre_req_primary.cert_pem_private_key_secret_arn
#   consul_secrets_arn        = module.pre_req_primary.consul_secrets_arn
#   common_tags               = var.common_tags
#   consul_agent = {
#     auto_reload_config = var.consul_agent.auto_reload_config
#     server             = var.consul_agent.server
#     ui                 = var.consul_agent.ui
#     join_environment   = var.consul_agent.join_environment
#     security_group_id  = module.pre_req_primary.server_security_group_id
#   }
#   environment_name       = var.consul_gateway_environment_name
#   consul_cluster_version = var.consul_gateway_cluster_version
#   ingress_gateway = {
#     enabled           = var.ingress_gateway.enabled
#     container_image   = var.ingress_gateway.container_image
#     service_name      = var.ingress_gateway.service_name
#     listener_ports    = var.ingress_gateway.listener_ports
#     ingress_cidrs     = var.ingress_gateway.ingress_cidrs
#     security_group_id = module.pre_req_primary.gateway_security_group_id
#   }
# }
