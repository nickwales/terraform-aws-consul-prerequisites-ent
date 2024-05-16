# AWS Secrets Manager Module  


## Purpose
These modules are currently for [hyper-specialized tier partners](https://www.hashicorp.com/partners/find-a-partner?category=systems-integrators), internal use, and HashiCorp Implementation Services. Please reach out in #team-ent-deployment-modules if you want to use this with your customers.


## Overview  
This module will establish multiple Secrets Manager secrets inside of AWS.  The module inputs contain three variables, a name prefix, a map of tags to be applied to the resources, and an object map of Secrets.  The variable `secretsmanager_secrets` is flexible in that it allows you to provide the module different types of secrets to be created.  

For example, the default values of the map in this module are  

``` hcl
type = object({
    license = optional(object({
      name        = optional(string)
      path        = optional(string, null)
      description = optional(string, "TFE license")
      data        = optional(string, null)
    }), {})
    tfe_console_password = optional(object({
      name               = optional(string, "console-password")
      description        = optional(string, "Console password used in the TFE installation")
      data               = optional(string, null)
    }), {})
    tfe_enc_password = optional(object({
      name           = optional(string, "enc-password")
      description    = optional(string, "Encryption password used in the TFE installation")
      data           = optional(string, null)
    }), {})
    ...{ommitted for brevity}...
    }))
  })
```  

Optionally, a `path` can be provided for license file secrets.  

Note that when `path` is specified the module will expect a file to be present at the path and convert the file into a SecretBinary object within Secrets Manager.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.55.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.5.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.55.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_id.gossip_gen](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.rpw](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_uuid.accessor_gen](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.token_gen](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_friendly_name_prefix"></a> [friendly\_name\_prefix](#input\_friendly\_name\_prefix) | Friendly name prefix used for tagging and naming AWS resources. | `string` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | Name of the HashiCorp product that will consume this service (tfe, tfefdo, vault, consul, nomad, boundary) | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of common tags for all taggable AWS resources. | `map(string)` | `{}` | no |
| <a name="input_optional_secrets"></a> [optional\_secrets](#input\_optional\_secrets) | Optional variable that when supplied will be merged with the `secretsmanager_secrets` map. These secrets need to have the following specification:<br>  optional\_secrets = {<br>    secret\_1 = {<br>      name = "supesecret"<br>      description = "it's my secret that is important"<br>      path = "path to file if you are using one"<br>      data = "string data if you are supplying it"<br>    }<br>    secret\_2 = {<br>      name = "supesecret2"<br>      description = "it's my secret that is also important probably"<br>      path = "path to file if you are using one"<br>      data = "string data if you are supplying it"<br>    }<br>  } | `map(any)` | `{}` | no |
| <a name="input_secretsmanager_secrets"></a> [secretsmanager\_secrets](#input\_secretsmanager\_secrets) | Object Map that contains various secrets that will be created and stored in AWS Secrets Manager. | <pre>object({<br>    consul = optional(object({<br>      license = optional(object({<br>        name        = optional(string, "consul-license")<br>        description = optional(string, "Consul license")<br>        data        = optional(string, null)<br>        path        = optional(string, null)<br>      }))<br>      acl_token = optional(object({<br>        name        = optional(string, "consul-acl-token")<br>        description = optional(string, "Consul default ACL token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      agent_token = optional(object({<br>        name        = optional(string, "consul-agent-token")<br>        description = optional(string, "Consul agent token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      gossip_key = optional(object({<br>        name        = optional(string, "consul-gossip-key")<br>        description = optional(string, "Consul Gossip encryption key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      snapshot_token = optional(object({<br>        name        = optional(string, "consul-snapshot-token")<br>        description = optional(string, "Consul Snapshot token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      replication_token = optional(object({<br>        name        = optional(string, "consul-replication-token")<br>        description = optional(string, "Consul Replication token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      mesh_gw_token = optional(object({<br>        name        = optional(string, "consul-mesh-gw-token")<br>        description = optional(string, "Consul Mesh Gateway token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>      ingress_gw_token = optional(object({<br>        name        = optional(string, "consul-ingress-gw-token")<br>        description = optional(string, "Consul gossip encryption key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>      terminating_gw_token = optional(object({<br>        name        = optional(string, "consul-terminating-gw-token")<br>        description = optional(string, "Consul Terminating Gateway key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>    }))<br>    replicated_license = optional(object({<br>      name        = optional(string, "tfe-replicated-license")<br>      path        = optional(string, null)<br>      description = optional(string, "license")<br>      data        = optional(string, null)<br>    }))<br>    tfe = optional(object({<br>      license = optional(object({<br>        name        = optional(string, "tfe-license")<br>        description = optional(string, "License for TFE FDO")<br>        data        = optional(string, null)<br>        path        = optional(string, null)<br>      }))<br>      enc_password = optional(object({<br>        name        = optional(string, "enc-password")<br>        description = optional(string, "Encryption password used in the TFE installation")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>      console_password = optional(object({<br>        name        = optional(string, "console-password")<br>        description = optional(string, "Console password used in the TFE installation")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>    }))<br>    boundary = optional(object({<br>      license = optional(object({<br>        name        = optional(string, "boundary-license")<br>        description = optional(string, "License for Boundary Enterprise")<br>        data        = optional(string, null)<br>        path        = optional(string, null)<br>      }))<br>      db_username = optional(object({<br>        name        = optional(string, "db-username")<br>        description = optional(string, "Username for the boundary database")<br>        data        = optional(string, "boundary")<br>      }))<br>      db_password = optional(object({<br>        name        = optional(string, "db-password")<br>        description = optional(string, "Password for the boundary database")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      hcp_username = optional(object({<br>        name        = optional(string, "hcp-username")<br>        description = optional(string, "HCP Boundary Username for Worker Registration")<br>        data        = optional(string, "boundary")<br>      }))<br>      hcp_password = optional(object({<br>        name        = optional(string, "hcp-password")<br>        description = optional(string, "HCP Boundary Password for Worker Registration")<br>        data        = optional(string, null)<br>      }))<br>    }))<br>    vault = optional(object({<br>      license = optional(object({<br>        name        = optional(string, "vault-license")<br>        description = optional(string, "Vault License")<br>        data        = optional(string, null)<br>        path        = optional(string, null)<br>      }))<br>    }))<br>    ca_certificate_bundle = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO CA certificate bundle")<br>      data        = optional(string, null)<br>    }))<br>    cert_pem_secret = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO PEM-encoded TLS certificate")<br>      data        = optional(string, null)<br>    }))<br>    cert_pem_private_key_secret = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO PEM-encoded TLS private key")<br>      data        = optional(string, null)<br>    }))<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_boundary_secrets_arn"></a> [boundary\_secrets\_arn](#output\_boundary\_secrets\_arn) | AWS Secrets Manager `boundary` secrets ARN. |
| <a name="output_ca_certificate_bundle_secret_arn"></a> [ca\_certificate\_bundle\_secret\_arn](#output\_ca\_certificate\_bundle\_secret\_arn) | AWS Secrets Manager BYO CA certificate bundle ARN. |
| <a name="output_cert_pem_private_key_secret_arn"></a> [cert\_pem\_private\_key\_secret\_arn](#output\_cert\_pem\_private\_key\_secret\_arn) | AWS Secrets Manager BYO CA certificate private key secret ARN. |
| <a name="output_cert_pem_secret_arn"></a> [cert\_pem\_secret\_arn](#output\_cert\_pem\_secret\_arn) | AWS Secrets Manager BYO CA certificate private key secret ARN. |
| <a name="output_consul_secrets_arn"></a> [consul\_secrets\_arn](#output\_consul\_secrets\_arn) | AWS Secrets Manager `consul` secrets ARN. |
| <a name="output_optional_secrets"></a> [optional\_secrets](#output\_optional\_secrets) | A map of optional secrets that have been created if they were supplied during the time of execution. Output is a single map where the key of the map for the secret is the key and the ARN is the value. |
| <a name="output_replicated_license_secret_arn"></a> [replicated\_license\_secret\_arn](#output\_replicated\_license\_secret\_arn) | AWS Secrets Manager `replicated` secret ARN. |
| <a name="output_secret_arn_list"></a> [secret\_arn\_list](#output\_secret\_arn\_list) | A list of AWS Secrets Manager ARNs produced by the module. |
| <a name="output_tfe_secrets_arn"></a> [tfe\_secrets\_arn](#output\_tfe\_secrets\_arn) | AWS Secrets Manager TFE secrets ARN. |
| <a name="output_vault_secrets_arn"></a> [vault\_secrets\_arn](#output\_vault\_secrets\_arn) | AWS Secrets Manager `vault` secrets ARN. |
<!-- END_TF_DOCS -->
