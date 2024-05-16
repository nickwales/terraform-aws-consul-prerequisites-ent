output "route53_resolver_endpoint_id" {
  value       = try(aws_route53_resolver_endpoint.consul.id, null)
  description = "ID of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_arn" {
  value       = try(aws_route53_resolver_endpoint.consul.arn, null)
  description = "ARN of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_name" {
  value       = try(aws_route53_resolver_endpoint.consul.name, null)
  description = "Name of the Route53 resolver that was created"
}

output "route53_resolver_endpoint_ip_address" {
  value       = try(aws_route53_resolver_endpoint.consul.ip_address, null)
  description = "IP addresses associated with the Route53 resolver that was created"
}

output "route53_resolver_endpoint_security_group_ids" {
  value       = try(aws_route53_resolver_endpoint.consul.security_group_ids, null)
  description = "Security group IDs associated with the Route53 resolver that was created"
}

output "route53_resolver_rule_domain_name" {
  value       = try(aws_route53_resolver_rule.fwd_consul.domain_name, null)
  description = "Domain name associated with the Route53 resolver rule that was created"
}

output "route53_resolver_rule_arn" {
  value       = try(aws_route53_resolver_rule.fwd_consul.arn, null)
  description = "ARN of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_id" {
  value       = try(aws_route53_resolver_rule.fwd_consul.id, null)
  description = "ID of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_name" {
  value       = try(aws_route53_resolver_rule.fwd_consul.name, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_target_ips" {
  value       = try(aws_route53_resolver_rule.fwd_consul.target_ip, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_resolver_rule_association_id" {
  value       = try(aws_route53_resolver_rule_association.consul.id, null)
  description = "Name of the the Route53 resolver rule that was created"
}

output "route53_security_group_id" {
  value       = try(aws_security_group.route53_forwarder.id, null)
  description = "ID of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_arn" {
  value       = try(aws_security_group.route53_forwarder.arn, null)
  description = "ARN of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}

output "route53_security_group_name" {
  value       = try(aws_security_group.route53_forwarder.name, null)
  description = "Name of the the security group that allows the Route53 resolver endpoint to communicate with Consul"
}