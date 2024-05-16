# Module Desciption

This is a helper module that pushes all of the tokens that have been generated via the secrets manager module into the Consul environment

<p>&nbsp;</p>

## Usage
Check out the examples directory!

1. Get your intial management token from AWS Secrets Manager
2. Place the value for it in the `terraform.auto.tfvars`
3. Place the ARN for the AWS Secrets Manager secret in the `terraform.auto.tfvars`
4. Replace the `consul_url` value in the `terraform.auto.tfvars` file.
5. Check the `providers.tf` to make sure it matches your deployment
6. `terraform init`
7. `terraform plan`
8. `terraform apply`

Please note that if you need to modify the default policies they are under the `policies` folder. These are generic by design.



### Example Scenarios. 

Links to examples and their readmes

- [basic-cluster-acl-push](./examples/basic-cluster-acl-push/README.md)

<p>&nbsp;</p>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |
| <a name="requirement_consul"></a> [consul](#requirement\_consul) | >= 2.18.0 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | >=1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |
| <a name="provider_consul"></a> [consul](#provider\_consul) | >= 2.18.0 |
| <a name="provider_terracurl"></a> [terracurl](#provider\_terracurl) | >=1.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [consul_acl_policy.policies](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_policy) | resource |
| [consul_acl_token_policy_attachment.policy_attach](https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/acl_token_policy_attachment) | resource |
| [terracurl_request.tokens](https://registry.terraform.io/providers/devops-rob/terracurl/latest/docs/resources/request) | resource |
| [aws_secretsmanager_secret_version.consul](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_consul_secrets_arn"></a> [consul\_secrets\_arn](#input\_consul\_secrets\_arn) | ARN of the Secrets Manager Secret that contains the Consul tokens. | `string` | n/a | yes |
| <a name="input_consul_token"></a> [consul\_token](#input\_consul\_token) | Consul token to use when making the API requests | `string` | n/a | yes |
| <a name="input_consul_url"></a> [consul\_url](#input\_consul\_url) | URL for the Consul Cluster to bootstrap the ACLs | `string` | n/a | yes |
| <a name="input_consul_ca_file"></a> [consul\_ca\_file](#input\_consul\_ca\_file) | Path on disk to the ca certificate to use when making the API request (if skip\_tls\_verify is false) | `string` | `""` | no |
| <a name="input_consul_cert_file"></a> [consul\_cert\_file](#input\_consul\_cert\_file) | Path on disk to the public certificate to use when making the API request (if skip\_tls\_verify is false) | `string` | `""` | no |
| <a name="input_consul_datacenters"></a> [consul\_datacenters](#input\_consul\_datacenters) | Datacenters where the ACL Policy will be created | `list(string)` | `null` | no |
| <a name="input_consul_key_file"></a> [consul\_key\_file](#input\_consul\_key\_file) | Path on disk to the private certificate to use when making the API request (if skip\_tls\_verify is false) | `string` | `""` | no |
| <a name="input_skip_tls_verify"></a> [skip\_tls\_verify](#input\_skip\_tls\_verify) | Boolean that when true, will skip the TLS verification for the API calls | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consul_acl_policies"></a> [consul\_acl\_policies](#output\_consul\_acl\_policies) | Map of the ACL Policies that were created as a result of the run |
| <a name="output_consul_acl_policy_attachment"></a> [consul\_acl\_policy\_attachment](#output\_consul\_acl\_policy\_attachment) | Map of the policies that were attached to each accessor id |
<!-- END_TF_DOCS -->
