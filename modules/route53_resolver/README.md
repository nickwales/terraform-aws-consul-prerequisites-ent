# route53_resolver

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_resolver_endpoint.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.fwd_consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_security_group.route53_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.dns_forwarder_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.dns_forwarder_udp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_network_interface.internal_nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_friendly_name_prefix"></a> [friendly\_name\_prefix](#input\_friendly\_name\_prefix) | String value for friendly name prefix for AWS resource names. | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of subnet-ids associated with the internal NLB. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID that will be used by the workloads. | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of common tags for taggable AWS resources. | `map(string)` | `{}` | no |
| <a name="input_product"></a> [product](#input\_product) | Name of the HashiCorp product that will be installed (tfe, vault, consul) | `string` | `"consul"` | no |
| <a name="input_route53_resolver_pool"></a> [route53\_resolver\_pool](#input\_route53\_resolver\_pool) | "Object map that contains the Route53 resolver pool configuration that will be used when creating the endpoints.<br>  \'lb\_arn\_suffix\' is required.<br>  \'consul\_domain\' is utilized for the route53 resolver domain and defaults to `dc1.consul`. Please adjust this domain if you are using a different datacenter or custom domain for Consul.<br>  " | <pre>object({<br>    enabled       = optional(bool, true)<br>    consul_domain = optional(string, "dc1.consul")<br>    lb_arn_suffix = optional(string, null)<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route53_resolver_endpoint_arn"></a> [route53\_resolver\_endpoint\_arn](#output\_route53\_resolver\_endpoint\_arn) | ARN of the Route53 resolver that was created |
| <a name="output_route53_resolver_endpoint_id"></a> [route53\_resolver\_endpoint\_id](#output\_route53\_resolver\_endpoint\_id) | ID of the Route53 resolver that was created |
| <a name="output_route53_resolver_endpoint_ip_address"></a> [route53\_resolver\_endpoint\_ip\_address](#output\_route53\_resolver\_endpoint\_ip\_address) | IP addresses associated with the Route53 resolver that was created |
| <a name="output_route53_resolver_endpoint_name"></a> [route53\_resolver\_endpoint\_name](#output\_route53\_resolver\_endpoint\_name) | Name of the Route53 resolver that was created |
| <a name="output_route53_resolver_endpoint_security_group_ids"></a> [route53\_resolver\_endpoint\_security\_group\_ids](#output\_route53\_resolver\_endpoint\_security\_group\_ids) | Security group IDs associated with the Route53 resolver that was created |
| <a name="output_route53_resolver_rule_arn"></a> [route53\_resolver\_rule\_arn](#output\_route53\_resolver\_rule\_arn) | ARN of the the Route53 resolver rule that was created |
| <a name="output_route53_resolver_rule_association_id"></a> [route53\_resolver\_rule\_association\_id](#output\_route53\_resolver\_rule\_association\_id) | Name of the the Route53 resolver rule that was created |
| <a name="output_route53_resolver_rule_domain_name"></a> [route53\_resolver\_rule\_domain\_name](#output\_route53\_resolver\_rule\_domain\_name) | Domain name associated with the Route53 resolver rule that was created |
| <a name="output_route53_resolver_rule_id"></a> [route53\_resolver\_rule\_id](#output\_route53\_resolver\_rule\_id) | ID of the the Route53 resolver rule that was created |
| <a name="output_route53_resolver_rule_name"></a> [route53\_resolver\_rule\_name](#output\_route53\_resolver\_rule\_name) | Name of the the Route53 resolver rule that was created |
| <a name="output_route53_resolver_rule_target_ips"></a> [route53\_resolver\_rule\_target\_ips](#output\_route53\_resolver\_rule\_target\_ips) | Name of the the Route53 resolver rule that was created |
| <a name="output_route53_security_group_arn"></a> [route53\_security\_group\_arn](#output\_route53\_security\_group\_arn) | ARN of the the security group that allows the Route53 resolver endpoint to communicate with Consul |
| <a name="output_route53_security_group_id"></a> [route53\_security\_group\_id](#output\_route53\_security\_group\_id) | ID of the the security group that allows the Route53 resolver endpoint to communicate with Consul |
| <a name="output_route53_security_group_name"></a> [route53\_security\_group\_name](#output\_route53\_security\_group\_name) | Name of the the security group that allows the Route53 resolver endpoint to communicate with Consul |
<!-- END_TF_DOCS -->