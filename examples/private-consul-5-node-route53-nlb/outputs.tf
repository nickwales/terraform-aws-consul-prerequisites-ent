#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.pre_req_primary.vpc_id
}

output "region" {
  description = "The AWS region where the resources have been created"
  value       = module.pre_req_primary.region
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.pre_req_primary.vpc_arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.pre_req_primary.vpc_cidr_block
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.pre_req_primary.default_security_group_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.pre_req_primary.private_subnet_ids
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.pre_req_primary.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.pre_req_primary.private_subnets_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = module.pre_req_primary.private_subnets_ipv6_cidr_blocks
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.pre_req_primary.public_subnet_ids
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.pre_req_primary.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = module.pre_req_primary.public_subnets_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = module.pre_req_primary.public_subnets_ipv6_cidr_blocks
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.pre_req_primary.public_route_table_ids
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.pre_req_primary.private_route_table_ids
}

#------------------------------------------------------------------------------
# S3
#------------------------------------------------------------------------------

output "s3_bucket_arn_list" {
  value       = module.pre_req_primary.s3_bucket_arn_list
  description = "A list of the ARNs for the buckets that have been configured"
}

output "s3_replication_iam_role_arn" {
  value       = module.pre_req_primary.s3_replication_iam_role_arn
  description = "ARN of IAM Role for S3 replication."
}

output "s3_snapshot_bucket_name" {
  value       = module.pre_req_primary.s3_snapshot_bucket_name
  description = "Name of S3 Consul Enterprise Object Store bucket."
}

output "s3_snapshot_bucket_arn" {
  value       = module.pre_req_primary.s3_snapshot_bucket_arn
  description = "ARN of S3 Consul Enterprise Object Store bucket."
}


#------------------------------------------------------------------------------
# KMS
#------------------------------------------------------------------------------
output "kms_key_arn" {
  value       = module.pre_req_primary.kms_key_arn
  description = "The KMS key used to encrypt data."
}

output "kms_key_alias" {
  value       = module.pre_req_primary.kms_key_alias
  description = "The KMS Key Alias"
}

output "kms_key_alias_arn" {
  value       = module.pre_req_primary.kms_key_alias_arn
  description = "The KMS Key Alias arn"
}

#------------------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------------------
output "consul_secrets_arn" {
  value       = module.pre_req_primary.consul_secrets_arn
  description = "AWS Secrets Manager Consul secrets ARN."
}

output "ca_certificate_bundle_secret_arn" {
  value       = module.pre_req_primary.ca_certificate_bundle_secret_arn
  description = "AWS Secrets Manager BYO CA certificate secret ARN."
}

output "cert_pem_secret_arn" {
  value       = module.pre_req_primary.cert_pem_secret_arn
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "cert_pem_private_key_secret_arn" {
  value       = module.pre_req_primary.cert_pem_private_key_secret_arn
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "secret_arn_list" {
  value       = module.pre_req_primary.secret_arn_list
  description = "A list of AWS Secrets Manager Arns produced by the module"
}

#------------------------------------------------------------------------------
# CloudWatch
#------------------------------------------------------------------------------
output "cloudwatch_log_group_name" {
  value       = module.pre_req_primary.cloudwatch_log_group_name
  description = "AWS CloudWatch Log Group Name."
}

#------------------------------------------------------------------------------
# SSH Key Pair
#------------------------------------------------------------------------------
output "ssh_keypair_name" {
  value       = module.pre_req_primary.ssh_keypair_name
  description = "Name of the keypair that was created (if specified)."
}

output "ssh_keypair_arn" {
  value       = module.pre_req_primary.ssh_keypair_arn
  description = "ARN of the keypair that was created (if specified)."
}

output "ssh_keypair_id" {
  value       = module.pre_req_primary.ssh_keypair_id
  description = "ID of the SSH Key Pair."
}

output "ssh_keypair_fingerprint" {
  value       = module.pre_req_primary.ssh_keypair_fingerprint
  description = "Fingerprint of the SSH Key Pair."
}

#------------------------------------------------------------------------------
# IAM Resources
#------------------------------------------------------------------------------
output "iam_role_arn" {
  value       = module.pre_req_primary.iam_role_arn
  description = "ARN of IAM Role in use by the Instances"
}

output "iam_role_name" {
  value       = module.pre_req_primary.iam_role_name
  description = "Name of IAM Role in use by the Instances"
}

output "iam_managed_policy_arn" {
  value       = module.pre_req_primary.iam_managed_policy_arn
  description = "ARN of IAM Managed Policy for the Instance Role"
}

output "iam_managed_policy_name" {
  value       = module.pre_req_primary.iam_managed_policy_name
  description = "Name of IAM Managed Policy for the Instance Role"
}

output "iam_instance_profile_arn" {
  value       = module.pre_req_primary.iam_instance_profile_arn
  description = "ARN of IAM Instance Profile for the Instance Role"
}

#------------------------------------------------------------------------------
# Ingress Resources
#------------------------------------------------------------------------------
output "lb_arn" {
  value       = module.pre_req_primary.lb_arn
  description = "The Resource Identifier of the LB"
}

output "lb_name" {
  value       = module.pre_req_primary.lb_name
  description = "Name of the LB"
}

output "lb_dns_name" {
  value       = module.pre_req_primary.lb_dns_name
  description = "The DNS name created with the LB"
}

output "lb_zone_id" {
  value       = module.pre_req_primary.lb_zone_id
  description = "The Zone ID of the LB"
}

output "lb_internal" {
  value       = module.pre_req_primary.lb_internal
  description = "Boolean value of the internal/external status of the LB.  Determines if the LB gets Elastic IPs assigned"
}

output "lb_security_group_ids" {
  value       = module.pre_req_primary.lb_security_group_ids
  description = "List of security group IDs in use by the LB"
}

output "lb_tg_arns" {
  value       = module.pre_req_primary.lb_tg_arns
  description = "List of target group ARNs for LB"
}

output "lb_type" {
  value       = module.pre_req_primary.lb_type
  description = "Type of LB created (ALB or NLB)"
}

output "acm_certificate_arn" {
  value       = module.pre_req_primary.acm_certificate_arn
  description = "The ARN of the certificate"
}

output "acm_certificate_status" {
  value       = module.pre_req_primary.acm_certificate_status
  description = "Status of the certificate"
}

output "acm_distinct_domain_names" {
  value       = module.pre_req_primary.acm_distinct_domain_names
  description = "List of distinct domains names used for the validation"
}

output "acm_validation_domains" {
  value       = module.pre_req_primary.acm_validation_domains
  description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards"
}

output "acm_validation_route53_record_fqdns" {
  value       = module.pre_req_primary.acm_validation_route53_record_fqdns
  description = "List of FQDNs built using the zone domain and name"
}

output "route53_regional_record_name" {
  value       = module.pre_req_primary.route53_regional_record_name
  description = "Name of the regional LB Route53 record name"
}

output "route53_regional_fqdn" {
  value       = module.pre_req_primary.route53_regional_fqdn
  description = "FQDN of regional LB Route53 record"
}

output "route53_failover_record_name" {
  value       = module.pre_req_primary.route53_failover_record_name
  description = "Name of the failover LB Route53 record name"
}

output "route53_failover_fqdn" {
  value       = module.pre_req_primary.route53_failover_fqdn
  description = "FQDN of failover LB Route53 record"
}

output "asg_hook_value" {
  value       = module.pre_req_primary.asg_hook_value
  description = "Value for the `asg-hook` tag that will be attatched to the instance in the other module. Use this value to ensure the lifecycle hook is updated during deployment."
}

output "route53_resolver_endpoint_id" {
  value       = module.pre_req_primary.route53_resolver_endpoint_id
  description = "ID of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_arn" {
  value       = module.pre_req_primary.route53_resolver_endpoint_arn
  description = "ARN of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_name" {
  value       = module.pre_req_primary.route53_resolver_endpoint_name
  description = "Name of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_ip_address" {
  value       = module.pre_req_primary.route53_resolver_endpoint_ip_address
  description = "IP addresses associated with the Route53 resolver that was created"
}

output "route53_resolver_endpoint_security_group_ids" {
  value       = module.pre_req_primary.route53_resolver_endpoint_security_group_ids
  description = "Security group IDs associated with the Route53 resolver that was created"
}

output "route53_resolver_rule_domain_name" {
  value       = module.pre_req_primary.route53_resolver_rule_domain_name
  description = "Domain name associated with the Route53 resolver rule that was created"
}

output "route53_resolver_rule_arn" {
  value       = module.pre_req_primary.route53_resolver_rule_arn
  description = "ARN of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_id" {
  value       = module.pre_req_primary.route53_resolver_rule_id
  description = "ID of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_name" {
  value       = module.pre_req_primary.route53_resolver_rule_name
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_target_ips" {
  value       = module.pre_req_primary.route53_resolver_rule_target_ips
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_association_id" {
  value       = module.pre_req_primary.route53_resolver_rule_association_id
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_security_group_id" {
  value       = module.pre_req_primary.route53_security_group_id
  description = "ID of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_arn" {
  value       = module.pre_req_primary.route53_security_group_arn
  description = "ARN of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_name" {
  value       = module.pre_req_primary.route53_security_group_name
  description = "Name of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

#------------------------------------------------------------------------------
# Security Group Resources
#------------------------------------------------------------------------------
output "consul_server_security_group_id" {
  value       = module.pre_req_primary.server_security_group_id
  description = "ID of the security group that created for Consul servers."
}

output "consul_server_security_group_arn" {
  value       = module.pre_req_primary.server_security_group_arn
  description = "ARN of the security group that created for Consul servers."
}

output "consul_server_security_group_name" {
  value       = module.pre_req_primary.server_security_group_name
  description = "Name of the security group that created for Consul servers."
}

output "consul_agent_security_group_name" {
  value       = module.pre_req_primary.agent_security_group_name
  description = "Name of the security group that created for Consul agents."
}

output "consul_agent_security_group_arn" {
  value       = module.pre_req_primary.agent_security_group_arn
  description = "ARN of the security group that created for Consul agents."
}

output "consul_agent_security_group_id" {
  value       = module.pre_req_primary.agent_security_group_id
  description = "ID of the security group that created for Consul agents."
}

output "consul_gateway_security_group_name" {
  value       = module.pre_req_primary.gateway_security_group_name
  description = "Name of the security group that created for Consul gateways."
}

output "consul_gateway_security_group_arn" {
  value       = module.pre_req_primary.gateway_security_group_arn
  description = "ARN of the security group that created for Consul gateways."
}

output "consul_gateway_security_group_id" {
  value       = module.pre_req_primary.gateway_security_group_id
  description = "ID of the security group that created for Consul gateways."
}

# Commented due to module call being commented
# #------------------------------------------------------------------------------
# # Consul Server Outputs
# #------------------------------------------------------------------------------
# output "server_user_data_script" {
#   value       = try(module.consul.user_data_script, null)
#   description = "base64 decoded user data script that is attached to the launch template"
# }

# output "server_launch_template_name" {
#   value       = try(module.consul.launch_template_name, null)
#   description = "Name of the AWS launch template that was created during the run"
# }

# output "server_asg_name" {
#   value       = try(module.consul.asg_name, null)
#   description = "Name of the AWS autoscaling group that was created during the run."
# }

# output "server_asg_healthcheck_type" {
#   value       = try(module.consul.asg_healthcheck_type, null)
#   description = "Type of health check that is associated with the AWS autoscaling group."
# }

# output "server_asg_target_group_arns" {
#   value       = try(module.consul.asg_target_group_arns, null)
#   description = "List of the target group ARNs that are used for the AWS autoscaling group"
# }

# #------------------------------------------------------------------------------
# # Consul Server Outputs
# #------------------------------------------------------------------------------
# output "agent_user_data_script" {
#   value       = try(module.agent.user_data_script, null)
#   description = "base64 decoded user data script that is attached to the launch template"
# }

# output "agent_launch_template_name" {
#   value       = try(module.agent.launch_template_name, null)
#   description = "Name of the AWS launch template that was created during the run"
# }

# output "agent_asg_name" {
#   value       = try(module.agent.asg_name, null)
#   description = "Name of the AWS autoscaling group that was created during the run."
# }

# output "agent_asg_healthcheck_type" {
#   value       = try(module.agent.asg_healthcheck_type, null)
#   description = "Type of health check that is associated with the AWS autoscaling group."
# }

# output "agent_asg_target_group_arns" {
#   value       = try(module.agent.asg_target_group_arns, null)
#   description = "List of the target group ARNs that are used for the AWS autoscaling group"
# }