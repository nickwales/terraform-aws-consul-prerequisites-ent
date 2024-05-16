# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "server_security_group_id" {
  description = "The ID of the server security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["controller"].id, null) : try(aws_security_group.loop["server"].id, null)
}

output "agent_security_group_id" {
  description = "The ID of the agent security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["worker"].id, null) : try(aws_security_group.loop["agent"].id, null)
}

output "server_security_group_arn" {
  description = "The ARN of the server security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["controller"].arn, null) : try(aws_security_group.loop["server"].arn, null)
}

output "agent_security_group_arn" {
  description = "The ARN of the agent security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["worker"].arn, null) : try(aws_security_group.loop["agent"].arn, null)
}

output "server_security_group_name" {
  description = "The name of the server security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["controller"].name, null) : try(aws_security_group.loop["server"].name, null)
}

output "agent_security_group_name" {
  description = "The name of the agent security group"
  value       = var.product == "boundary" ? try(aws_security_group.loop["worker"].name, null) : try(aws_security_group.loop["agent"].name, null)
}

output "gateway_security_group_name" {
  description = "The name of the gateway security group"
  value       = try(aws_security_group.loop["gateway"].name, null)
}

output "gateway_security_group_arn" {
  description = "The name of the gateway security group"
  value       = try(aws_security_group.loop["gateway"].arn, null)
}

output "gateway_security_group_id" {
  description = "The name of the gateway security group"
  value       = try(aws_security_group.loop["gateway"].id, null)
}