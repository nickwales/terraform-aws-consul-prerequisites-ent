# Overview  

This module provides some general automation around generating self-signed certificates via Terraform. These then can be used with the root module folder 2 directories up. This module will generate the following objects:

**Root Module**
-  Public Key
-  Private Key  
-  Certificate Chain
 
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.ca](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [local_file.pub_key_no_root](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [tls_cert_request.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) | resource |
| [tls_locally_signed_cert.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.server](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_shared_san"></a> [shared\_san](#input\_shared\_san) | This is a shared server name that the certs for all Consul nodes contain. Example of this is consul.mydomain.com. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca"></a> [ca](#output\_ca) | CA certificate that signed the SSL certs |
| <a name="output_private"></a> [private](#output\_private) | Private key file for the Vault nodes |
| <a name="output_public"></a> [public](#output\_public) | Public key file for the Vault nodes |
<!-- END_TF_DOCS -->