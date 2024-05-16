# basic-cluster-acl-push

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | >= 2.18.0 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | >=1.1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acl_init"></a> [acl\_init](#module\_acl\_init) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_consul_secrets_arn"></a> [consul\_secrets\_arn](#input\_consul\_secrets\_arn) | ARN of the Secrets Manager Secret that contains the Consul tokens. | `string` | n/a | yes |
| <a name="input_consul_token"></a> [consul\_token](#input\_consul\_token) | Consul token to use when making the API requests | `string` | n/a | yes |
| <a name="input_consul_url"></a> [consul\_url](#input\_consul\_url) | URL for the Consul Cluster to bootstrap the ACLs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consul_acl_policies"></a> [consul\_acl\_policies](#output\_consul\_acl\_policies) | Map of the ACL Policies that were created as a result of the run |
| <a name="output_consul_acl_policy_attachment"></a> [consul\_acl\_policy\_attachment](#output\_consul\_acl\_policy\_attachment) | Map of the policies that were attached to each accessor id |
<!-- END_TF_DOCS -->