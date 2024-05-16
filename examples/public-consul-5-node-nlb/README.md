# Public Consul Enterprise single site with an NLB Example

This module is an example of utilizing the `terraform-aws-consul-prerequisites` module. Users can use this to deploy prerequisite infrastructure required to install Consul Enterprise into AWS 

## Description

This module showcases an example of utilizing the root module of this repository to build out the following high level components for a Public Consul Enterprise **single-site** deployment inside of AWS in a **specific region**:  

**Root Module**  
-  VPC with Public and Private access  
-  VPC Endpoints  
-  Secrets Manager Secrets  
-  S3 buckets
-  Network Load Balancer, Listeners, and Target Groups  
-  Route 53 entries 
-  KMS Encryption Keys  
-  Log Groups 
-  SSH KeyPair 
- Security Groups

## Getting Started

### Dependencies

* Terraform or Terraform Cloud for seeding
* Route53 Zone
* A valid certificate for Consul.
* Consul Enterprise License

---

### 📝 Note
If you already have the prerequisites created, please see the other repository for the examples that focus on the deployment of the product only rather than the underlying infrastructre. They can be found here [terraform-aws-consul](https://github.com/hashicorp-modules/terraform-aws-consul) module under `/examples/`.  

#### Supplemental Modules
>There is a **supplemental-modules** folder and within that there is some sample code that will generate certificates for the deployment. These will be untrusted certificates but will allow you to get up and running. you can modify the values in `supplemental-modules/generate-cert/terraform-auto.tfvars.example` and then do a `terraform plan` and `terraform apply`. This will create certificates within the `parent folder for the example` and can be referenced in the main run.

---

### Executing program

Modify the `terraform.auto.tfvars.example` file with parameters pertinent to your environment.  As part of the example, some settings are pre-selected or marked as recommended or required. 


``` hcl
terraform init
terraform plan
terraform apply
```

The deployment will take roughly 14-30 minutes to complete.  

#### Deploying Consul

If you want to also deploy a Consul cluster as a part of the example, please uncomment the example **AFTER** the prerequisites are deployed. Once that is done you can run the commands below:

``` hcl
terraform init
terraform plan
terraform apply
```
##### Bootstrap the ACL system

Once the cluster is up and running, you can now bootstrap the ACL system. Under the `supplemental-modules` folder, there is an example of bootstrapping the environment using Terraform. You will need the following values to bootstrap the ACL system.

##### Export method
Here are the bash commands you can run to export the required values in order to use the module.

```bash
export TF_VAR_consul_secrets_arn=$(terraform output -raw consul_secrets_arn)
export TF_VAR_consul_url=$(terraform output -raw route53_failover_fqdn):8501
export AWS_REGION=$(echo $TF_VAR_consul_secrets_arn | awk -F: '{print $4}')
export TF_VAR_consul_token=$(aws secretsmanager get-secret-value --secret-id $TF_VAR_consul_secrets_arn --region $AWS_REGION | jq -r .SecretString | jq .acl_token.data | sed 's/"//g')
```

Now `cd` into `supplemental-modules/consul-acl-init` and verify the content in `main.tf`. We have the certificates that it will use as static inputs. If you have them somewhere else, please edit them accordingly.

Once you verify everything is all set, just do:

``` hcl
terraform init
terraform plan
terraform apply
```
---

#### Manual method

If you can't (or won't) use these, Here is what you need to do
1. `terraform output -raw consul_secrets_arn`
2. `terraform output -raw route53_failover_fqdn`
3. `aws secretsmanager get-secret-value --secret-id <<YOUR-SECRET-ARN-FROM-STEP-1>> --region <<YOUR-AWS-REGION>> | jq -r .SecretString | jq .acl_token.data | sed 's/"//g'`

This should give you the following information:
```bash
└─ ❯ terraform output -raw consul_secrets_arn
arn:aws:secretsmanager:us-east-2:441170333099:secret:kalen-c73ded-consul-9hlOof

└─ ❯ terraform output -raw route53_failover_fqdn
consul.hashicat.aws.sbx.hashicorpdemo.com

└─ ❯ aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-2:441170333099:secret:kalen-c73ded-consul-9hlOof --region us-east-2| jq -r .SecretString | jq .acl_token.data | sed 's/"//g'
1499fc0b-461b-7051-5448-b34b99cccf2e
```

1. Now take these values and `cd` into `supplemental-modules/consul-acl-init` and uncomment the variable values in `terraform.auto.tfvars.example`. 
2. Paste the values you have from above.
3. Rename `terraform.auto.tfvars.example` to `terraform.auto.tfvars`
4. Check the certificate paths in `main.tf`. If those are all set do the following: 
``` hcl
terraform init
terraform plan
terraform apply
```

Now you can uncomment the other services like the ingress gateway module call or the example agents and they will be able to join the cluster and retreive their licenses.

---

#### Retrieve the initial management token
You can login to secrets manager and pull the secret via the UI. If you want to do this in more of an automated manner, you can use the following commands below:


```bash
consul_secrets_arn=$(terraform output -raw consul_secrets_arn)
AWS_REGION=$(echo $consul_secrets_arn | awk -F: '{print $4}')
aws secretsmanager get-secret-value --secret-id $consul_secrets_arn --region $AWS_REGION | jq -r .SecretString | jq .acl_token.data | sed 's/"//g'
```

Proceed with the rest of the service deployments
---

## Authors

* Kalen Arndt  
* Sean Doyle  


## Acknowledgments

HashiCorp PS and HashiCorp Engineering have been huge inspirations for this effort

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.55.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.4 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent"></a> [agent](#module\_agent) | github.com/hashicorp-modules/terraform-aws-consul | v0.0.2-beta |
| <a name="module_consul"></a> [consul](#module\_consul) | github.com/hashicorp-modules/terraform-aws-consul | v0.0.2-beta |
| <a name="module_pre_req_primary"></a> [pre\_req\_primary](#module\_pre\_req\_primary) | ../../ | n/a |
| <a name="module_tgw"></a> [tgw](#module\_tgw) | github.com/hashicorp-modules/terraform-aws-consul | v0.0.2-beta |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_consul_agent"></a> [consul\_agent](#input\_consul\_agent) | Object map that contains the configuration for the Consul agent that will be deployed on the workloads within the environment. | <pre>object({<br>    container_image               = optional(string, "hashicorp/consul-enterprise:1.16.0-ent")<br>    server                        = optional(bool, false)<br>    domain                        = optional(string, "consul")<br>    datacenter                    = optional(string, "dc1")<br>    primary_datacenter            = optional(string, "dc1")<br>    join_environment              = optional(string, "primary")<br>    ui                            = optional(bool, false)<br>    log_level                     = optional(string, "INFO")<br>    partition                     = optional(string, "")<br>    auto_reload_config            = optional(bool, true)<br>    enable_central_service_config = optional(bool, true)<br>    enable_grpc                   = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_consul_agent_cluster_version"></a> [consul\_agent\_cluster\_version](#input\_consul\_agent\_cluster\_version) | SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config) | `string` | n/a | yes |
| <a name="input_consul_agent_environment_name"></a> [consul\_agent\_environment\_name](#input\_consul\_agent\_environment\_name) | Unique environment name to prefix and disambiguate resources using. | `string` | n/a | yes |
| <a name="input_consul_gateway_cluster_version"></a> [consul\_gateway\_cluster\_version](#input\_consul\_gateway\_cluster\_version) | SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config) | `string` | n/a | yes |
| <a name="input_consul_gateway_environment_name"></a> [consul\_gateway\_environment\_name](#input\_consul\_gateway\_environment\_name) | Unique environment name to prefix and disambiguate resources using. | `string` | n/a | yes |
| <a name="input_consul_server_agent"></a> [consul\_server\_agent](#input\_consul\_server\_agent) | Object map that contains the configuration for the Consul agent that will be deployed on the workloads within the environment. | <pre>object({<br>    container_image               = optional(string, "hashicorp/consul-enterprise:1.16.0-ent")<br>    server                        = optional(bool, true)<br>    domain                        = optional(string, "consul")<br>    datacenter                    = optional(string, "dc1")<br>    primary_datacenter            = optional(string, "dc1")<br>    join_environment              = optional(string, "primary")<br>    ui                            = optional(bool, false)<br>    log_level                     = optional(string, "INFO")<br>    partition                     = optional(string, "")<br>    auto_reload_config            = optional(bool, true)<br>    enable_central_service_config = optional(bool, true)<br>    enable_grpc                   = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_consul_server_cluster_version"></a> [consul\_server\_cluster\_version](#input\_consul\_server\_cluster\_version) | SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config) | `string` | n/a | yes |
| <a name="input_consul_server_environment_name"></a> [consul\_server\_environment\_name](#input\_consul\_server\_environment\_name) | Unique environment name to prefix and disambiguate resources using. | `string` | n/a | yes |
| <a name="input_friendly_name_prefix"></a> [friendly\_name\_prefix](#input\_friendly\_name\_prefix) | Friendly name prefix used for tagging and naming AWS resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of common tags for all taggable AWS resources. | `map(string)` | `{}` | no |
| <a name="input_iam_resources"></a> [iam\_resources](#input\_iam\_resources) | A list of objects for to be referenced in an IAM policy for the instance.  Each is a list of strings that reference infra related to the install | <pre>object({<br>    bucket_arns             = optional(list(string), [])<br>    kms_key_arns            = optional(list(string), [])<br>    secret_manager_arns     = optional(list(string), [])<br>    log_group_arn           = optional(string, "")<br>    log_forwarding_enabled  = optional(bool, true)<br>    role_name               = optional(string, "consul-role")<br>    policy_name             = optional(string, "consul-policy")<br>    ssm_enable              = optional(bool, false)<br>    cloud_auto_join_enabled = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_ingress_gateway"></a> [ingress\_gateway](#input\_ingress\_gateway) | Configuration object to deploy a Consul ingress gateway. | <pre>object({<br>    enabled         = optional(bool, false)<br>    container_image = optional(string, "")<br>    service_name    = optional(string, "")<br>    listener_ports  = optional(list(number), [])<br>    ingress_cidrs   = optional(list(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_lb_internal"></a> [lb\_internal](#input\_lb\_internal) | Boolean to determine if the Load Balancer will be internal or internet facing | `bool` | `false` | no |
| <a name="input_lb_listener_details"></a> [lb\_listener\_details](#input\_lb\_listener\_details) | Configures the LB Listeners for various HashiCorp Products | <pre>object({<br>    consul_dns = optional(object({<br>      create      = optional(bool, true)<br>      port        = optional(number, 53)<br>      ssl_policy  = optional(string, "")<br>      action_type = optional(string, "forward")<br>    }), {})<br>    consul_mesh_gateway = optional(object({<br>      create      = optional(bool, true)<br>      port        = optional(number, 443)<br>      ssl_policy  = optional(string, "")<br>      action_type = optional(string, "forward")<br>    }))<br>    consul_api = optional(object({<br>      create      = optional(bool, false)<br>      port        = optional(number, 8500)<br>      ssl_policy  = optional(string, "ELBSecurityPolicy-TLS-1-2-2017-01")<br>      action_type = optional(string, "forward")<br>    }), {})<br>    consul_api_tls = optional(object({<br>      create      = optional(bool, true)<br>      port        = optional(number, 8501)<br>      ssl_policy  = optional(string, "ELBSecurityPolicy-TLS-1-2-2017-01")<br>      action_type = optional(string, "forward")<br>    }), {})<br>    consul_ingress_gateway = optional(object({<br>      create      = optional(bool, true)<br>      port        = optional(number, 8080)<br>      ssl_policy  = optional(string, "")<br>      action_type = optional(string, "forward")<br>    }))<br>    consul_grpc_tls = optional(object({<br>      create      = optional(bool, true)<br>      port        = optional(number, 8502)<br>      ssl_policy  = optional(string, "")<br>      action_type = optional(string, "forward")<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_lb_target_groups"></a> [lb\_target\_groups](#input\_lb\_target\_groups) | Object map for the Load Balancer Target Group configuration | <pre>object({<br>    consul_dns = optional(object({<br>      create               = optional(bool, true)<br>      name                 = optional(string, "consul-dns-tg")<br>      description          = optional(string, "Target Group for Consul DNS traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8600)<br>      protocol             = optional(string, "TCP_UDP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, true)<br>        port                = optional(string, "8600")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }))<br>    }))<br>    consul_mesh_gateway = optional(object({<br>      create               = optional(bool, true)<br>      name                 = optional(string, "consul-mesh-gw-tg")<br>      description          = optional(string, "Target Group for Consul Mesh Gateway traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8443)<br>      protocol             = optional(string, "TCP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, true)<br>        port                = optional(string, "8443")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }))<br>    }))<br>    consul_api = optional(object({<br>      create               = optional(bool, false)<br>      name                 = optional(string, "consul-api-tg")<br>      description          = optional(string, "Target Group for Consul api traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8500)<br>      protocol             = optional(string, "TCP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, false)<br>        port                = optional(string, "8500")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }))<br>    }))<br>    consul_api_tls = optional(object({<br>      create               = optional(bool, true)<br>      name                 = optional(string, "consul-api-tls-tg")<br>      description          = optional(string, "Target Group for Consul api traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8501)<br>      protocol             = optional(string, "TCP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, true)<br>        port                = optional(string, "8501")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }), {})<br>    }), {})<br>    consul_grpc_tls = optional(object({<br>      create               = optional(bool, true)<br>      name                 = optional(string, "consul-grpc-tls-tg")<br>      description          = optional(string, "Target Group for Consul GRPC traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8500)<br>      protocol             = optional(string, "TCP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, true)<br>        port                = optional(string, "8500")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }))<br>    }))<br>    consul_ingress_gateway = optional(object({<br>      create               = optional(bool, true)<br>      name                 = optional(string, "consul-ing-gw-tg")<br>      description          = optional(string, "Target Group for Consul Ingress Gateway traffic")<br>      deregistration_delay = optional(number, 15)<br>      port                 = optional(number, 8080)<br>      protocol             = optional(string, "TCP")<br>      health_check = optional(object({<br>        enabled             = optional(bool, true)<br>        port                = optional(string, "8080")<br>        healthy_threshold   = optional(number, 2)<br>        unhealthy_threshold = optional(number, 2)<br>        timeout             = optional(number, 5)<br>        interval            = optional(number, 10)<br>        matcher             = optional(string, "200-299")<br>        path                = optional(string, "")<br>        protocol            = optional(string, "TCP")<br>      }))<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_lb_type"></a> [lb\_type](#input\_lb\_type) | Type of load balancer that will be provisioned as a part of the module execution (if specified). | `string` | `"network"` | no |
| <a name="input_log_forwarding_enabled"></a> [log\_forwarding\_enabled](#input\_log\_forwarding\_enabled) | Boolean that when true, will enable log forwarding to Cloud Watch | `bool` | `true` | no |
| <a name="input_route53_failover_record"></a> [route53\_failover\_record](#input\_route53\_failover\_record) | If set, creates a Route53 failover record.  Ensure that the record name is the same between both modules.  Also, the Record ID needs to be unique per module | <pre>object({<br>    create              = optional(bool, true)<br>    set_id              = optional(string, "fso1")<br>    lb_failover_primary = optional(bool, true)<br>    record_name         = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_route53_resolver_pool"></a> [route53\_resolver\_pool](#input\_route53\_resolver\_pool) | "Object map that contains the Route53 resolver pool configuration that will be used when creating the endpoints.<br>  \'consul\_domain\' is utilized for the route53 resolver domain and defaults to `dc1.consul`. Please adjust this domain if you are using a different datacenter or custom domain for Consul.<br>  " | <pre>object({<br>    enabled       = optional(bool, false)<br>    consul_domain = optional(string, "dc1.consul")<br>  })</pre> | `{}` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route 53 public zone name | `string` | `""` | no |
| <a name="input_s3_buckets"></a> [s3\_buckets](#input\_s3\_buckets) | Object Map that contains the configuration for the S3 bucket configuration used in the installers. | <pre>object({<br>    snapshot = optional(object({<br>      create                              = optional(bool, true)<br>      bucket_name                         = optional(string, "vault-snapshot-bucket")<br>      description                         = optional(string, "Storage location for Vault snapshots that will be exported")<br>      versioning                          = optional(bool, true)<br>      force_destroy                       = optional(bool, false)<br>      replication                         = optional(bool, false)<br>      replication_destination_bucket_arn  = optional(string)<br>      replication_destination_kms_key_arn = optional(string)<br>      encrypt                             = optional(bool, true)<br>      bucket_key_enabled                  = optional(bool, true)<br>      kms_key_arn                         = optional(string)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_secretsmanager_secrets"></a> [secretsmanager\_secrets](#input\_secretsmanager\_secrets) | Object Map that contains various secrets that will be created and stored in AWS Secrets Manager. | <pre>object({<br>    consul = optional(object({<br>      license = optional(object({<br>        name        = optional(string, "consul-license")<br>        description = optional(string, "Consul license")<br>        data        = optional(string, null)<br>        path        = optional(string, null)<br>      }))<br>      acl_token = optional(object({<br>        name        = optional(string, "consul-acl-token")<br>        description = optional(string, "Consul default ACL token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      agent_token = optional(object({<br>        name        = optional(string, "consul-agent-token")<br>        description = optional(string, "Consul agent token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      gossip_key = optional(object({<br>        name        = optional(string, "consul-gossip-key")<br>        description = optional(string, "Consul Gossip encryption key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      snapshot_token = optional(object({<br>        name        = optional(string, "consul-snapshot-token")<br>        description = optional(string, "Consul Snapshot token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      replication_token = optional(object({<br>        name        = optional(string, "consul-replication-token")<br>        description = optional(string, "Consul Replication token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, true)<br>      }))<br>      mesh_gw_token = optional(object({<br>        name        = optional(string, "consul-mesh-gw-token")<br>        description = optional(string, "Consul Mesh Gateway token")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>      ingress_gw_token = optional(object({<br>        name        = optional(string, "consul-ingress-gw-token")<br>        description = optional(string, "Consul gossip encryption key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>      terminating_gw_token = optional(object({<br>        name        = optional(string, "consul-terminating-gw-token")<br>        description = optional(string, "Consul Terminating Gateway key")<br>        data        = optional(string, null)<br>        generate    = optional(bool, false)<br>      }))<br>    }))<br>    ca_certificate_bundle = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO CA certificate bundle")<br>      data        = optional(string, null)<br>    }))<br>    cert_pem_secret = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO PEM-encoded TLS certificate")<br>      data        = optional(string, null)<br>    }))<br>    cert_pem_private_key_secret = optional(object({<br>      name        = optional(string, null)<br>      path        = optional(string, null)<br>      description = optional(string, "BYO PEM-encoded TLS private key")<br>      data        = optional(string, null)<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Object Map that contains various configurations for the HashiCorp Product systems which when configured, will be deployed. | <pre>object({<br>    consul = optional(object({<br>      server = optional(object({<br>        rpc = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8300)<br>          to_port      = optional(number, 8300)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Server ingress RPC traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string, "agent")<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        serf_lan_tcp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8301)<br>          to_port      = optional(number, 8302)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Server TCP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string, "agent")<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        serf_lan_udp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8301)<br>          to_port      = optional(number, 8302)<br>          protocol     = optional(string, "udp")<br>          description  = optional(string, "Consul Server UDP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string, "agent")<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        dns_tcp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8600)<br>          to_port      = optional(number, 8600)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Server TCP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, true)<br>        }), {})<br>        dns_udp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8600)<br>          to_port      = optional(number, 8600)<br>          protocol     = optional(string, "udp")<br>          description  = optional(string, "Consul Server UDP DNS traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, true)<br>        }), {})<br>        https_api = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8501)<br>          to_port      = optional(number, 8501)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul server HTTPS api traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        http_api = optional(object({<br>          enabled      = optional(bool, false)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8500)<br>          to_port      = optional(number, 8500)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul server HTTP api traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        grpc = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8502)<br>          to_port      = optional(number, 8502)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul server HTTPS api traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        grpc_tls = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8503)<br>          to_port      = optional(number, 8503)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul server HTTPS api traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>      }), {})<br>      agent = optional(object({<br>        rpc = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "egress")<br>          from_port    = optional(number, 8300)<br>          to_port      = optional(number, 8300)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul agent egress RPC traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string, "server")<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        serf_lan_tcp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8301)<br>          to_port      = optional(number, 8302)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Server TCP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        serf_lan_udp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8301)<br>          to_port      = optional(number, 8302)<br>          protocol     = optional(string, "udp")<br>          description  = optional(string, "Consul Server UDP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, true)<br>        }), {})<br>        dns_tcp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8600)<br>          to_port      = optional(number, 8600)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Server TCP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, true)<br>        }), {})<br>        dns_udp = optional(object({<br>          enabled      = optional(bool, true)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8600)<br>          to_port      = optional(number, 8600)<br>          protocol     = optional(string, "udp")<br>          description  = optional(string, "Consul Server TCP Serf traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>      }), {})<br>      gateway = optional(object({<br>        mesh_gateway = optional(object({<br>          enabled      = optional(bool, false)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8443)<br>          to_port      = optional(number, 8443)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Mesh Gateway traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>        ingress_gateway = optional(object({<br>          enabled      = optional(bool, false)<br>          type         = optional(string, "ingress")<br>          from_port    = optional(number, 8080)<br>          to_port      = optional(number, 8080)<br>          protocol     = optional(string, "tcp")<br>          description  = optional(string, "Consul Ingress Gateway traffic")<br>          self         = optional(bool, true)<br>          target_sg    = optional(string)<br>          cidr_blocks  = optional(list(string))<br>          bidrectional = optional(bool, false)<br>        }), {})<br>      }), {})<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_snapshot_agent"></a> [snapshot\_agent](#input\_snapshot\_agent) | Configuration object to enable the Consul snapshot agent. | <pre>object({<br>    enabled        = optional(bool, false)<br>    interval       = optional(string, "")<br>    retention      = optional(number, 0)<br>    s3_bucket_name = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public key material for SSH Key Pair. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the certificate |
| <a name="output_acm_certificate_status"></a> [acm\_certificate\_status](#output\_acm\_certificate\_status) | Status of the certificate |
| <a name="output_acm_distinct_domain_names"></a> [acm\_distinct\_domain\_names](#output\_acm\_distinct\_domain\_names) | List of distinct domains names used for the validation |
| <a name="output_acm_validation_domains"></a> [acm\_validation\_domains](#output\_acm\_validation\_domains) | List of distinct domain validation options. This is useful if subject alternative names contain wildcards |
| <a name="output_acm_validation_route53_record_fqdns"></a> [acm\_validation\_route53\_record\_fqdns](#output\_acm\_validation\_route53\_record\_fqdns) | List of FQDNs built using the zone domain and name |
| <a name="output_asg_hook_value"></a> [asg\_hook\_value](#output\_asg\_hook\_value) | Value for the `asg-hook` tag that will be attatched to the instance in the other module. Use this value to ensure the lifecycle hook is updated during deployment. |
| <a name="output_ca_certificate_bundle_secret_arn"></a> [ca\_certificate\_bundle\_secret\_arn](#output\_ca\_certificate\_bundle\_secret\_arn) | AWS Secrets Manager BYO CA certificate secret ARN. |
| <a name="output_cert_pem_private_key_secret_arn"></a> [cert\_pem\_private\_key\_secret\_arn](#output\_cert\_pem\_private\_key\_secret\_arn) | AWS Secrets Manager BYO CA certificate private key secret ARN. |
| <a name="output_cert_pem_secret_arn"></a> [cert\_pem\_secret\_arn](#output\_cert\_pem\_secret\_arn) | AWS Secrets Manager BYO CA certificate private key secret ARN. |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | AWS CloudWatch Log Group Name. |
| <a name="output_consul_agent_security_group_arn"></a> [consul\_agent\_security\_group\_arn](#output\_consul\_agent\_security\_group\_arn) | ARN of the security group that created for Consul agents. |
| <a name="output_consul_agent_security_group_id"></a> [consul\_agent\_security\_group\_id](#output\_consul\_agent\_security\_group\_id) | ID of the security group that created for Consul agents. |
| <a name="output_consul_agent_security_group_name"></a> [consul\_agent\_security\_group\_name](#output\_consul\_agent\_security\_group\_name) | Name of the security group that created for Consul agents. |
| <a name="output_consul_gateway_security_group_arn"></a> [consul\_gateway\_security\_group\_arn](#output\_consul\_gateway\_security\_group\_arn) | ARN of the security group that created for Consul gateways. |
| <a name="output_consul_gateway_security_group_id"></a> [consul\_gateway\_security\_group\_id](#output\_consul\_gateway\_security\_group\_id) | ID of the security group that created for Consul gateways. |
| <a name="output_consul_gateway_security_group_name"></a> [consul\_gateway\_security\_group\_name](#output\_consul\_gateway\_security\_group\_name) | Name of the security group that created for Consul gateways. |
| <a name="output_consul_secrets_arn"></a> [consul\_secrets\_arn](#output\_consul\_secrets\_arn) | AWS Secrets Manager Consul secrets ARN. |
| <a name="output_consul_server_security_group_arn"></a> [consul\_server\_security\_group\_arn](#output\_consul\_server\_security\_group\_arn) | ARN of the security group that created for Consul servers. |
| <a name="output_consul_server_security_group_id"></a> [consul\_server\_security\_group\_id](#output\_consul\_server\_security\_group\_id) | ID of the security group that created for Consul servers. |
| <a name="output_consul_server_security_group_name"></a> [consul\_server\_security\_group\_name](#output\_consul\_server\_security\_group\_name) | Name of the security group that created for Consul servers. |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn) | ARN of IAM Instance Profile for the Instance Role |
| <a name="output_iam_managed_policy_arn"></a> [iam\_managed\_policy\_arn](#output\_iam\_managed\_policy\_arn) | ARN of IAM Managed Policy for the Instance Role |
| <a name="output_iam_managed_policy_name"></a> [iam\_managed\_policy\_name](#output\_iam\_managed\_policy\_name) | Name of IAM Managed Policy for the Instance Role |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM Role in use by the Instances |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of IAM Role in use by the Instances |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | The KMS Key Alias |
| <a name="output_kms_key_alias_arn"></a> [kms\_key\_alias\_arn](#output\_kms\_key\_alias\_arn) | The KMS Key Alias arn |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The KMS key used to encrypt data. |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The Resource Identifier of the LB |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name created with the LB |
| <a name="output_lb_internal"></a> [lb\_internal](#output\_lb\_internal) | Boolean value of the internal/external status of the LB.  Determines if the LB gets Elastic IPs assigned |
| <a name="output_lb_name"></a> [lb\_name](#output\_lb\_name) | Name of the LB |
| <a name="output_lb_security_group_ids"></a> [lb\_security\_group\_ids](#output\_lb\_security\_group\_ids) | List of security group IDs in use by the LB |
| <a name="output_lb_tg_arns"></a> [lb\_tg\_arns](#output\_lb\_tg\_arns) | List of target group ARNs for LB |
| <a name="output_lb_type"></a> [lb\_type](#output\_lb\_type) | Type of LB created (ALB or NLB) |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The Zone ID of the LB |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_private_subnets_ipv6_cidr_blocks"></a> [private\_subnets\_ipv6\_cidr\_blocks](#output\_private\_subnets\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of private subnets in an IPv6 enabled VPC |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_public_subnets_ipv6_cidr_blocks"></a> [public\_subnets\_ipv6\_cidr\_blocks](#output\_public\_subnets\_ipv6\_cidr\_blocks) | List of IPv6 cidr\_blocks of public subnets in an IPv6 enabled VPC |
| <a name="output_region"></a> [region](#output\_region) | The AWS region where the resources have been created |
| <a name="output_route53_failover_fqdn"></a> [route53\_failover\_fqdn](#output\_route53\_failover\_fqdn) | FQDN of failover LB Route53 record |
| <a name="output_route53_failover_record_name"></a> [route53\_failover\_record\_name](#output\_route53\_failover\_record\_name) | Name of the failover LB Route53 record name |
| <a name="output_route53_regional_fqdn"></a> [route53\_regional\_fqdn](#output\_route53\_regional\_fqdn) | FQDN of regional LB Route53 record |
| <a name="output_route53_regional_record_name"></a> [route53\_regional\_record\_name](#output\_route53\_regional\_record\_name) | Name of the regional LB Route53 record name |
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
| <a name="output_s3_bucket_arn_list"></a> [s3\_bucket\_arn\_list](#output\_s3\_bucket\_arn\_list) | A list of the ARNs for the buckets that have been configured |
| <a name="output_s3_replication_iam_role_arn"></a> [s3\_replication\_iam\_role\_arn](#output\_s3\_replication\_iam\_role\_arn) | ARN of IAM Role for S3 replication. |
| <a name="output_s3_snapshot_bucket_arn"></a> [s3\_snapshot\_bucket\_arn](#output\_s3\_snapshot\_bucket\_arn) | ARN of S3 Consul Enterprise Object Store bucket. |
| <a name="output_s3_snapshot_bucket_name"></a> [s3\_snapshot\_bucket\_name](#output\_s3\_snapshot\_bucket\_name) | Name of S3 Consul Enterprise Object Store bucket. |
| <a name="output_secret_arn_list"></a> [secret\_arn\_list](#output\_secret\_arn\_list) | A list of AWS Secrets Manager Arns produced by the module |
| <a name="output_ssh_keypair_arn"></a> [ssh\_keypair\_arn](#output\_ssh\_keypair\_arn) | ARN of the keypair that was created (if specified). |
| <a name="output_ssh_keypair_fingerprint"></a> [ssh\_keypair\_fingerprint](#output\_ssh\_keypair\_fingerprint) | Fingerprint of the SSH Key Pair. |
| <a name="output_ssh_keypair_id"></a> [ssh\_keypair\_id](#output\_ssh\_keypair\_id) | ID of the SSH Key Pair. |
| <a name="output_ssh_keypair_name"></a> [ssh\_keypair\_name](#output\_ssh\_keypair\_name) | Name of the keypair that was created (if specified). |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->