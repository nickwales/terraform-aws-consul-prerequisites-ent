#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.networking[0].vpc_id, null)
}

output "region" {
  description = "The AWS region where the resources have been created"
  value       = data.aws_region.current.name
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(module.networking[0].vpc_arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(module.networking[0].vpc_cidr_block, null)
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(module.networking[0].default_security_group_id, null)
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = try(module.networking[0].private_subnet_ids, null)
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = try(module.networking[0].private_subnet_arns, null)
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = try(module.networking[0].private_subnets_cidr_blocks, null)
}

output "private_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of private subnets in an IPv6 enabled VPC"
  value       = try(module.networking[0].private_subnets_ipv6_cidr_blocks, null)
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = try(module.networking[0].public_subnet_ids, null)
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = try(module.networking[0].public_subnet_arns, null)
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = try(module.networking[0].public_subnets_cidr_blocks, null)
}

output "public_subnets_ipv6_cidr_blocks" {
  description = "List of IPv6 cidr_blocks of public subnets in an IPv6 enabled VPC"
  value       = try(module.networking[0].public_subnets_ipv6_cidr_blocks, null)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = try(module.networking[0].public_route_table_ids, null)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = try(module.networking[0].private_route_table_ids, null)
}

output "tls_endpoint_security_group_id" {
  description = "ID for the TLS security group that is created for endpoint access."
  value       = try(module.networking[0].tls_endpoint_security_group_id, null)
}

output "tls_endpoint_security_group_name" {
  description = "Name for the TLS security group that is created for endpoint access."
  value       = try(module.networking[0].tls_endpoint_security_group_name, null)
}

#------------------------------------------------------------------------------
# S3
#------------------------------------------------------------------------------

output "s3_bucket_arn_list" {
  value       = try(module.s3[0].s3_bucket_arn_list, null)
  description = "A list of the ARNs for the buckets that have been configured"
}

output "s3_replication_iam_role_arn" {
  value       = try(module.s3[0].s3_replication_iam_role_arn, null)
  description = "ARN of IAM Role for S3 replication."
}

output "s3_snapshot_bucket_name" {
  value       = try(module.s3[0].s3_snapshot_bucket_name, null)
  description = "Name of S3 Enterprise Object Store bucket."
}

output "s3_snapshot_bucket_arn" {
  value       = try(module.s3[0].s3_snapshot_bucket_arn, null)
  description = "ARN of S3 Enterprise Object Store bucket."
}


#------------------------------------------------------------------------------
# KMS
#------------------------------------------------------------------------------
output "kms_key_arn" {
  value       = try(module.kms[0].kms_key_arn, null)
  description = "The KMS key used to encrypt data."
}

output "kms_key_alias" {
  value       = try(module.kms[0].kms_key_alias, null)
  description = "The KMS Key Alias"
}

output "kms_key_alias_arn" {
  value       = try(module.kms[0].kms_key_alias_arn, null)
  description = "The KMS Key Alias arn"
}

#------------------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------------------
output "consul_secrets_arn" {
  value       = try(module.secrets_manager[0].consul_secrets_arn, null)
  description = "AWS Secrets Manager `consul` secrets ARN."
}

output "secret_arn_list" {
  value       = try(module.secrets_manager[0].secret_arn_list, null)
  description = "AWS Secrets Manager ARNS in list format."
}

output "ca_certificate_bundle_secret_arn" {
  value       = try(module.secrets_manager[0].ca_certificate_bundle_secret_arn, null)
  description = "AWS Secrets Manager BYO CA certificate secret ARN."
}

output "cert_pem_secret_arn" {
  value       = try(module.secrets_manager[0].cert_pem_secret_arn, null)
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "cert_pem_private_key_secret_arn" {
  value       = try(module.secrets_manager[0].cert_pem_private_key_secret_arn, null)
  description = "AWS Secrets Manager BYO CA certificate private key secret ARN."
}

output "optional_secrets" {
  value       = try(module.secrets_manager[0].optional_secrets, null)
  description = "A map of optional secrets that have been created if they were supplied during the time of execution. Output is a single map where the key of the map for the secret is the key and the ARN is the value."
}

#------------------------------------------------------------------------------
# CloudWatch
#------------------------------------------------------------------------------
output "cloudwatch_log_group_name" {
  value       = try(aws_cloudwatch_log_group.consul[0].name, null)
  description = "AWS CloudWatch Log Group Name."
}

#------------------------------------------------------------------------------
# SSH Key Pair
#------------------------------------------------------------------------------
output "ssh_keypair_name" {
  value       = try(aws_key_pair.ssh[0].key_name, null)
  description = "Name of the keypair that was created (if specified)."
}

output "ssh_keypair_arn" {
  value       = try(aws_key_pair.ssh[0].arn, null)
  description = "ARN of the keypair that was created (if specified)."
}

output "ssh_keypair_id" {
  value       = try(aws_key_pair.ssh[0].key_pair_id, null)
  description = "ID of the SSH Key Pair."
}

output "ssh_keypair_fingerprint" {
  value       = try(aws_key_pair.ssh[0].fingerprint, null)
  description = "Fingerprint of the SSH Key Pair."
}

#------------------------------------------------------------------------------
# IAM Resources
#------------------------------------------------------------------------------
output "iam_role_arn" {
  value       = try(module.iam[0].iam_role_arn, null)
  description = "ARN of IAM Role in use by the Instances"
}

output "iam_role_name" {
  value       = try(module.iam[0].iam_role_name, null)
  description = "Name of IAM Role in use by the Instances"
}

output "iam_managed_policy_arn" {
  value       = try(module.iam[0].iam_managed_policy_arn, null)
  description = "ARN of IAM Managed Policy for the Instance Role"
}

output "iam_managed_policy_name" {
  value       = try(module.iam[0].iam_managed_policy_name, null)
  description = "Name of IAM Managed Policy for the Instance Role"
}

output "iam_instance_profile_arn" {
  value       = try(module.iam[0].iam_instance_profile, null)
  description = "ARN of IAM Instance Profile for the Instance Role"
}

output "iam_asg_service_role" {
  value       = try(module.iam[0].asg_role_arn, null)
  description = "ARN of AWS Service Linked Role for AWS EC2 AutoScaling"
}

#------------------------------------------------------------------------------
# Ingress Resources
#------------------------------------------------------------------------------
output "lb_arn" {
  value       = try(module.ingress[0].lb_arn, null)
  description = "The Resource Identifier of the LB"
}

output "lb_arn_suffix" {
  value       = try(module.ingress[0].lb_arn_suffix, null)
  description = "ARN Suffix for use iwth CloudWatch Metrics."
}

output "lb_name" {
  value       = try(module.ingress[0].lb_name, null)
  description = "Name of the LB"
}

output "lb_dns_name" {
  value       = try(module.ingress[0].lb_dns_name, null)
  description = "The DNS name created with the LB"
}

output "lb_zone_id" {
  value       = try(module.ingress[0].lb_zone_id, null)
  description = "The Zone ID of the LB"
}

output "lb_internal" {
  value       = try(module.ingress[0].internal, null)
  description = "Boolean value of the internal/external status of the LB.  Determines if the LB gets Elastic IPs assigned"
}

output "lb_security_group_ids" {
  value       = try(module.ingress[0].lb_security_group_ids, null)
  description = "List of security group IDs in use by the LB"
}

output "lb_tg_arns_map" {
  value       = try(module.ingress[0].lb_tg_arns_map, {})
  description = "Map of target group ARNs to Target Group Object Key"
}

output "lb_tg_arns" {
  value       = try(module.ingress[0].lb_tg_arns, [])
  description = "List of target group ARNs for LB"
}

output "lb_type" {
  value       = try(module.ingress[0].lb_type, null)
  description = "Type of LB created (ALB or NLB)"
}

output "acm_certificate_arn" {
  value       = try(module.ingress[0].acm_certificate_arn, null)
  description = "The ARN of the certificate"
}

output "acm_certificate_status" {
  value       = try(module.ingress[0].acm_certificate_status, null)
  description = "Status of the certificate"
}

output "acm_distinct_domain_names" {
  value       = try(module.ingress[0].acm_distinct_domain_names, null)
  description = "List of distinct domains names used for the validation"
}

output "acm_validation_domains" {
  value       = try(module.ingress[0].acm_validation_domains, null)
  description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards"
}

output "acm_validation_route53_record_fqdns" {
  value       = try(module.ingress[0].acm_validation_route53_record_fqdns, null)
  description = "List of FQDNs built using the zone domain and name"
}

output "route53_regional_record_name" {
  value       = try(module.ingress[0].route53_regional_record_name, null)
  description = "Name of the regional LB Route53 record name"
}

output "route53_regional_fqdn" {
  value       = try(module.ingress[0].route53_regional_fqdn, null)
  description = "FQDN of regional LB Route53 record"
}

output "route53_failover_record_name" {
  value       = try(module.ingress[0].route53_failover_record_name, null)
  description = "Name of the failover LB Route53 record name"
}

output "route53_failover_fqdn" {
  value       = try(module.ingress[0].route53_failover_fqdn, null)
  description = "FQDN of failover LB Route53 record"
}

output "asg_hook_value" {
  value       = try(module.iam[0].asg_hook_value, null)
  description = "Value for the `asg-hook` tag that will be attached to the instance in the other module. Use this value to ensure the lifecycle hook is updated during deployment."
}

output "route53_resolver_endpoint_id" {
  value       = try(module.route53_resolver[0].route53_resolver_endpoint_id, null)
  description = "ID of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_arn" {
  value       = try(module.route53_resolver[0].route53_resolver_endpoint_arn, null)
  description = "ARN of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_name" {
  value       = try(module.route53_resolver[0].route53_resolver_endpoint_name, null)
  description = "Name of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_ip_address" {
  value       = try(module.route53_resolver[0].route53_resolver_endpoint_ip_address, null)
  description = "IP addresses associated with the Route53 resolver that was created"
}

output "route53_resolver_endpoint_security_group_ids" {
  value       = try(module.route53_resolver[0].route53_resolver_endpoint_security_group_ids, null)
  description = "Security group IDs associated with the Route53 resolver that was created"
}

output "route53_resolver_rule_domain_name" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_domain_name, null)
  description = "Domain name associated with the Route53 resolver rule that was created"
}

output "route53_resolver_rule_arn" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_arn, null)
  description = "ARN of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_id" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_id, null)
  description = "ID of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_name" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_name, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_target_ips" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_target_ips, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_association_id" {
  value       = try(module.route53_resolver[0].route53_resolver_rule_association_id, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_security_group_id" {
  value       = try(module.route53_resolver[0].route53_security_group_id, null)
  description = "ID of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_arn" {
  value       = try(module.route53_resolver[0].route53_security_group_arn, null)
  description = "ARN of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_name" {
  value       = try(module.route53_resolver[0].route53_security_group_name, null)
  description = "Name of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "gateway_security_group_name" {
  description = "The name of the gateway security group"
  value       = try(module.sg[0].gateway_security_group_name, null)
}

output "gateway_security_group_arn" {
  description = "The name of the gateway security group"
  value       = try(module.sg[0].gateway_security_group_arn, null)
}

output "gateway_security_group_id" {
  description = "The name of the gateway security group"
  value       = try(module.sg[0].gateway_security_group_id, null)
}

output "server_security_group_id" {
  description = "The ID of the server security group"
  value       = try(module.sg[0].server_security_group_id, null)
}

output "agent_security_group_id" {
  description = "The ID of the agent security group"
  value       = try(module.sg[0].agent_security_group_id, null)
}

output "server_security_group_name" {
  description = "The name of the server security group"
  value       = try(module.sg[0].server_security_group_name, null)
}

output "server_security_group_arn" {
  description = "The name of the server security group"
  value       = try(module.sg[0].server_security_group_arn, null)
}

output "agent_security_group_name" {
  description = "The name of the agent security group"
  value       = try(module.sg[0].agent_security_group_name, null)
}

output "agent_security_group_arn" {
  description = "The name of the agent security group"
  value       = try(module.sg[0].agent_security_group_arn, null)
}