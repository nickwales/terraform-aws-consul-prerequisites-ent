# Hashicorp Product Security Group Module
This Terraform module is intended to dynamically build all required security groups and rules for enterprise products. 

---

## Purpose
This module exists due to the amount of rules are required for Consul to function depending on which services are configured within an environment. This module is able to generate a security group per purpose along with rules for inter security group, cidr, self, and egress all. 

Currently this module only supports the following products:
1. Consul
2. Boundary

The variable structure is there for TFE and TFEFDO but due to the limited ports associated with the product, we haven't incorporated it as it's requirements don't justify the complexity of this module.

## Usage

1. Specify what product you are deploying via `var.product`
2. Specify the VPC ID via `var.vpc_id`
3. Fill out the input `var.rules` based on your use case. Example below is for a generic Consul deployment.
4. `terraform init`
5. `terraform plan`
6. `terraform apply`

#### Example Variable definition.
```hcl
rules = {
  consul = {
    server = {
      rpc = {
        enabled   = true
        self      = true
        target_sg = "agent"
      }
      serf_lan_tcp = {
        enabled   = true
        self      = true
        target_sg = "agent"
      }
      serf_lan_udp = {
        enabled   = true
        self      = true
        target_sg = "agent"
      }
      dns_tcp = {
        enabled    = true
        self       = true
        bidrection = true
      }
      dns_udp = {
        enabled    = true
        self       = true
        bidrection = true
      }
      https_api = {
        enabled    = true
        self       = true
        bidrection = false
      }
      grpc = {
        enabled    = true
        self       = true
        bidrection = false
      }
      grpc_tls = {
        enabled    = true
        self       = true
        bidrection = false
      }
    }
    agent = {
      rpc = {
        enabled = true
        self    = true
      }
      serf_lan_tcp = {
        enabled = true
        self    = true
      }
      serf_lan_udp = {
        enabled = true
        self    = true
      }
      dns_tcp = {
        enabled       = true
        self          = true
        bidirectional = true
      }
      dns_udp = {
        enabled       = true
        self          = true
        bidirectional = true
      }
      serf_lan_udp = {
        enabled = true
        self    = true
      }
    }
  }
}
```
---


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.loop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cidr_agents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cidr_gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cidr_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ec2_allow_all_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.inter_sg_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.inter_sg_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.inter_sg_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_friendly_name_prefix"></a> [friendly\_name\_prefix](#input\_friendly\_name\_prefix) | String value for friendly name prefix for AWS resource names. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Name of the HashiCorp product that will be installed (tfe, tfefdo, vault, consul, boundary) | `string` | n/a | yes |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Object Map that contains various configurations for the HashiCorp Product systems which when configured, will be deployed. | <pre>object({<br>    consul = optional(object({<br>      server = optional(object({<br>        rpc = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8300)<br>          to_port       = optional(number, 8300)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Server ingress RPC traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }), {})<br>        serf_lan_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8301)<br>          to_port       = optional(number, 8302)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Server TCP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }), {})<br>        serf_lan_udp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8301)<br>          to_port       = optional(number, 8302)<br>          protocol      = optional(string, "udp")<br>          description   = optional(string, "Consul Server UDP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }))<br>        dns_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8600)<br>          to_port       = optional(number, 8600)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Server TCP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }))<br>        dns_udp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8600)<br>          to_port       = optional(number, 8600)<br>          protocol      = optional(string, "udp")<br>          description   = optional(string, "Consul Server UDP DNS traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }))<br>        https_api = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8501)<br>          to_port       = optional(number, 8501)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul server HTTPS api traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        http_api = optional(object({<br>          enabled       = optional(bool, false)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8500)<br>          to_port       = optional(number, 8500)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul server HTTP api traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        grpc = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8502)<br>          to_port       = optional(number, 8502)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul server HTTPS api traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        grpc_tls = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8503)<br>          to_port       = optional(number, 8503)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul server HTTPS api traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>      }), {})<br>      agent = optional(object({<br>        rpc = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "egress")<br>          from_port     = optional(number, 8300)<br>          to_port       = optional(number, 8300)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul agent egress RPC traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string, "server")<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }), {})<br>        serf_lan_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8301)<br>          to_port       = optional(number, 8302)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Server TCP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        serf_lan_udp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8301)<br>          to_port       = optional(number, 8302)<br>          protocol      = optional(string, "udp")<br>          description   = optional(string, "Consul Server UDP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }))<br>        dns_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8600)<br>          to_port       = optional(number, 8600)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Server TCP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, true)<br>        }))<br>        dns_udp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8600)<br>          to_port       = optional(number, 8600)<br>          protocol      = optional(string, "udp")<br>          description   = optional(string, "Consul Server TCP Serf traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>      }))<br>      gateway = optional(object({<br>        mesh_gateway = optional(object({<br>          enabled       = optional(bool, false)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8443)<br>          to_port       = optional(number, 8443)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Mesh Gateway traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        ingress_gateway = optional(object({<br>          enabled       = optional(bool, false)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 8080)<br>          to_port       = optional(number, 8080)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Consul Ingress Gateway traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>      }))<br>    }), {})<br>    tfe    = optional(object({}))<br>    tfefdo = optional(object({}))<br>    vault  = optional(object({}))<br>    boundary = optional(object({<br>      controller = optional(object({<br>        ssh = optional(object({<br>          enabled       = optional(bool, false)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 22)<br>          to_port       = optional(number, 22)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "SSH Traffic to Controller")<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        api_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 9200)<br>          to_port       = optional(number, 9200)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Boundary API traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        cluster_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 9201)<br>          to_port       = optional(number, 9201)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Boundary cluster traffic from workers")<br>          self          = optional(bool, false)<br>          target_sg     = optional(string, "worker")<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>      }))<br>      worker = optional(object({<br>        proxy_tcp = optional(object({<br>          enabled       = optional(bool, true)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 9202)<br>          to_port       = optional(number, 9202)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "Worker proxy traffic")<br>          self          = optional(bool, true)<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>        ssh = optional(object({<br>          enabled       = optional(bool, false)<br>          type          = optional(string, "ingress")<br>          from_port     = optional(number, 22)<br>          to_port       = optional(number, 22)<br>          protocol      = optional(string, "tcp")<br>          description   = optional(string, "SSH Traffic to Worker")<br>          target_sg     = optional(string)<br>          cidr_blocks   = optional(list(string))<br>          bidirectional = optional(bool, false)<br>        }))<br>      }))<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID that will be used by the workloads. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of common tags for taggable AWS resources. | `map(string)` | `{}` | no |
| <a name="input_permit_all_egress"></a> [permit\_all\_egress](#input\_permit\_all\_egress) | Whether broad (0.0.0.0/0) egress should be permitted on cluster nodes. If disabled, additional rules must be added to permit HTTP(S) and other necessary network access. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_security_group_arn"></a> [agent\_security\_group\_arn](#output\_agent\_security\_group\_arn) | The ARN of the agent security group |
| <a name="output_agent_security_group_id"></a> [agent\_security\_group\_id](#output\_agent\_security\_group\_id) | The ID of the agent security group |
| <a name="output_agent_security_group_name"></a> [agent\_security\_group\_name](#output\_agent\_security\_group\_name) | The name of the agent security group |
| <a name="output_gateway_security_group_arn"></a> [gateway\_security\_group\_arn](#output\_gateway\_security\_group\_arn) | The name of the gateway security group |
| <a name="output_gateway_security_group_id"></a> [gateway\_security\_group\_id](#output\_gateway\_security\_group\_id) | The name of the gateway security group |
| <a name="output_gateway_security_group_name"></a> [gateway\_security\_group\_name](#output\_gateway\_security\_group\_name) | The name of the gateway security group |
| <a name="output_server_security_group_arn"></a> [server\_security\_group\_arn](#output\_server\_security\_group\_arn) | The ARN of the server security group |
| <a name="output_server_security_group_id"></a> [server\_security\_group\_id](#output\_server\_security\_group\_id) | The ID of the server security group |
| <a name="output_server_security_group_name"></a> [server\_security\_group\_name](#output\_server\_security\_group\_name) | The name of the server security group |
<!-- END_TF_DOCS -->