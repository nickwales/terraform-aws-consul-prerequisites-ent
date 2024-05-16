locals {
  product_sg_rules = {
    for product, rules in lookup(var.security_group_rules, var.product, {}) :
    product => rules if rules != null
  }

  # Loops through the supplied rules and adds a new key `source_sg` with the value of the outer key as the value
  sg_source_labels = {
    for key, value in local.product_sg_rules :
    key => {
      for inner_key, inner_value in value :
      inner_key => merge(inner_value, { "source_sg" = key }) if try(inner_value.enabled, false)
    } if value != null
  }

  # helper to make the bidrectional a bit easier to read
  type_switcher = {
    "ingress" = "egress"
    "egress"  = "ingress"
  }

  # determines all of the rules that have `bidirectional = true` and then builds a new map with the value of `type` appended to the key. This map is then merged into the main rule map.
  modified_rules = {
    for key, value in local.sg_source_labels : key => merge(value, {
      for subkey, subvalue in value : "${subkey}_${lookup(local.type_switcher, subvalue.type, subkey)}" => {
        enabled       = subvalue.enabled
        type          = lookup(local.type_switcher, subvalue.type, subvalue.type)
        from_port     = subvalue.from_port
        to_port       = subvalue.to_port
        protocol      = subvalue.protocol
        description   = subvalue.description
        target_sg     = subvalue.target_sg
        cidr_blocks   = subvalue.cidr_blocks
        source_sg     = subvalue.source_sg
        bidirectional = try(subvalue.bidirectional, false)
      } if subvalue.bidirectional
    })
  }

  # Sort all rules in the server sub-map that have `self = true`
  server_self_sort = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "controller" : "server")) :
  key => value if try(value.self, false) }, {})

  # Sort all rules in the agent sub-map that have `self = true`
  agent_self_sort = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "worker" : "agent")) :
  key => value if try(value.self, false) }, {})

  # Inter security group maps for agents
  agent_targets = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "worker" : "agent")) :
  key => value if try(value.target_sg, null) != null }, {})

  # Inter security group maps for servers
  server_targets = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "controller" : "server")) :
  key => value if try(value.target_sg, null) != null }, {})

  # Rules that have cidr blocks for agents
  agent_cidr_rules = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "worker" : "agent")) :
  key => value if try(value.cidr_blocks, null) != null }, {})

  # Rules that have cidr blocks for servers
  server_cidr_rules = try({ for key, value in lookup(local.modified_rules, (var.product == "boundary" ? "controller" : "server")) :
  key => value if try(value.cidr_blocks, null) != null }, {})

  # Rules that have cidr blocks for servers
  gateway_cidr_rules = try({ for key, value in lookup(local.modified_rules, "gateway") :
  key => value if try(value.cidr_blocks, null) != null }, {})

  # Inter security group maps for servers
  gateway_targets = try({ for key, value in lookup(local.modified_rules, "gateway") :
  key => value if try(value.target_sg, null) != null }, {})

  # Sort all rules in the agent sub-map that have `self = true`
  gateway_self_sort = try({ for key, value in lookup(local.modified_rules, "gateway") :
  key => value if try(value.self, false) }, {})
}

resource "aws_security_group" "loop" {
  for_each = local.sg_source_labels
  name     = "${var.friendly_name_prefix}-${var.product}-${each.key}"
  vpc_id   = var.vpc_id
  tags     = var.common_tags
}

resource "aws_security_group_rule" "self_servers" {
  for_each    = local.server_self_sort
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  self        = each.value.self
  description = each.value.description

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "self_agent" {
  for_each    = local.agent_self_sort
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  self        = each.value.self
  description = each.value.description

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "self_gateway" {
  for_each    = local.gateway_self_sort
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  self        = each.value.self
  description = each.value.description

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "inter_sg_agent" {
  for_each    = local.agent_targets
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  source_security_group_id = !contains(["server", "agent", "gateway", "lb", "controller", "worker"], each.value.target_sg) ? each.value.target_sg : aws_security_group.loop[each.value.target_sg].id
  security_group_id        = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "inter_sg_server" {
  for_each    = local.server_targets
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  source_security_group_id = !contains(["server", "agent", "gateway", "lb", "controller", "worker"], each.value.target_sg) ? each.value.target_sg : aws_security_group.loop[each.value.target_sg].id
  security_group_id        = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "inter_sg_gateway" {
  for_each    = local.gateway_targets
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description

  source_security_group_id = !contains(["server", "agent", "gateway", "lb", "controller", "worker"], each.value.target_sg) ? each.value.target_sg : aws_security_group.loop[each.value.target_sg].id
  security_group_id        = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "cidr_agents" {
  for_each    = local.agent_cidr_rules
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description
  cidr_blocks = each.value.cidr_blocks

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "cidr_servers" {
  for_each    = local.server_cidr_rules
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description
  cidr_blocks = each.value.cidr_blocks

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "cidr_gateways" {
  for_each    = local.gateway_cidr_rules
  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  description = each.value.description
  cidr_blocks = each.value.cidr_blocks

  security_group_id = aws_security_group.loop[each.value.source_sg].id
}

resource "aws_security_group_rule" "ec2_allow_all_outbound" {
  for_each    = var.permit_all_egress ? aws_security_group.loop : {}
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all traffic egress from ${var.product}"

  security_group_id = aws_security_group.loop[each.key].id
}
