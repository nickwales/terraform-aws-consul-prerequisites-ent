#------------------------------------------------------------------------------
# R53 Resolver
#------------------------------------------------------------------------------

data "aws_network_interface" "internal_nlb" {
  for_each = { for idx, subnet in var.private_subnet_ids : idx => subnet }

  filter {
    name   = "description"
    values = ["ELB ${var.route53_resolver_pool.lb_arn_suffix}"]
  }

  filter {
    name   = "subnet-id"
    values = [each.value]
  }
}

resource "aws_route53_resolver_endpoint" "consul" {
  name               = "${var.friendly_name_prefix}-${var.product}-resolver"
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.route53_forwarder.id]
  dynamic "ip_address" {
    for_each = { for idx, subnet in var.private_subnet_ids : idx => subnet }
    content {
      subnet_id = ip_address.value
    }
  }
}

resource "aws_route53_resolver_rule" "fwd_consul" {
  domain_name          = var.route53_resolver_pool.consul_domain
  rule_type            = "FORWARD"
  name                 = "${var.friendly_name_prefix}-resolver-rule"
  resolver_endpoint_id = aws_route53_resolver_endpoint.consul.id

  dynamic "target_ip" {
    for_each = data.aws_network_interface.internal_nlb
    content {
      ip = target_ip.value.private_ip
    }
  }
}

resource "aws_route53_resolver_rule_association" "consul" {
  resolver_rule_id = aws_route53_resolver_rule.fwd_consul.id
  vpc_id           = var.vpc_id
}

resource "aws_security_group" "route53_forwarder" {
  name   = "${var.friendly_name_prefix}-${var.product}-route53-forwarder"
  vpc_id = var.vpc_id
  tags   = var.common_tags
}

resource "aws_security_group_rule" "dns_forwarder_tcp" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [for eni in data.aws_network_interface.internal_nlb : "${eni.private_ip}/32"]
  description       = "Permit Route53 resolver to communicate with DNS nodes ${var.product}"
  security_group_id = aws_security_group.route53_forwarder.id
}

resource "aws_security_group_rule" "dns_forwarder_udp" {
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [for eni in data.aws_network_interface.internal_nlb : "${eni.private_ip}/32"]
  description       = "Permit Route53 resolver to communicate with DNS nodes ${var.product}"
  security_group_id = aws_security_group.route53_forwarder.id
}
