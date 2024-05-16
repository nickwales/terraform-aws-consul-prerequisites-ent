# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

variable "product" {
  type        = string
  description = "Name of the HashiCorp product that will consume this service (tfe, tfenext, vault, consul)"
  validation {
    condition     = contains(["tfe", "tfenext", "vault", "consul"], var.product)
    error_message = "`var.product` must be \"tfe\", \"tfenext\", \"vault\", or \"consul\"."
  }
  default = "consul"
}

#------------------------------------------------------------------------------
# Conditional Variables
#------------------------------------------------------------------------------

variable "create_vpc" {
  description = "Boolean that when true will create a VPC for Terraform Enterprise to use. If this is false then a vpc_id must be provided."
  type        = bool
  default     = true
}

variable "create_secrets" {
  description = "Boolean that when true will create the required secrets and store them in AWS Secrets Manager for the installation. If this is not set to true then the ARNs for the required secrets must be specified"
  type        = bool
  default     = true
}

variable "create_kms" {
  description = "Boolean that when true will create the KMS keys for the S3 buckets to use"
  type        = bool
  default     = true
}

variable "create_lb" {
  type        = bool
  description = "Boolean value to indicate to create a LoadBalancer"
  default     = true
}

variable "create_s3_buckets" {
  description = "Boolean that when true will create the S3 buckets required for the installation"
  type        = bool
  default     = true
}

variable "create_iam_resources" {
  type        = bool
  description = "Flag to create IAM Resources"
  default     = true
}

variable "create_log_group" {
  description = "Boolean that when true will create the cloud watch log group."
  type        = bool
  default     = true
}

variable "create_ssh_keypair" {
  type        = bool
  description = "Boolean to deploy SSH key pair. This does not create the private key, it only creates the key pair with a provided public key."
  default     = false
}
#------------------------------------------------------------------------------
# KMS
#------------------------------------------------------------------------------

variable "kms_key_description" {
  description = "Description that will be attached to the KMS key (if created)"
  type        = string
  default     = "AWS KMS Customer-managed key to encrypt TFE RDS, S3, EBS, etc."
}

variable "kms_key_usage" {
  description = "Intended use of the KMS key that will be created."
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_key_deletion_window" {
  type        = number
  description = "Duration in days to destroy the key after it is deleted. Must be between 7 and 30 days."
  default     = 7
}

variable "kms_allow_asg_to_cmk" {
  type        = bool
  description = "Boolen to create a KMS CMK Key policy that grants the Service Linked Role AWSServiceRoleForAutoScaling permissions to the CMK."
  default     = true
}

variable "kms_asg_role_arns" {
  type        = list(string)
  description = "List of ARNs of AWS Service Linked role for AWS Autoscaling."
  default     = []
}

variable "kms_key_name" {
  description = "Name that will be added to the KMS key via tags"
  type        = string
  default     = "kms-key"
}

variable "kms_default_policy_enabled" {
  description = "Enables a default policy that allows KMS operations to be defined by IAM"
  type        = string
  default     = true
}

variable "kms_key_users_or_roles" {
  type        = list(string)
  description = "List of arns for users or roles that should have access to perform Cryptographic Operations with KMS Key"
  default     = []
}

#------------------------------------------------------------------------------
# Network
#------------------------------------------------------------------------------

variable "vpc_name" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
  default     = "vault-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC."
  default     = "10.1.0.0/16"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC that the cluster will use. (Only used if var.create_vpc is false)"
  default     = null
}

variable "vpc_enable_ssm" {
  type        = bool
  description = "Boolean that when true will create a security group allowing port 443 to the private_subnets within the VPC (if create_vpc is true)"
  default     = false
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR ranges to create in VPC."
  default     = ["10.1.255.0/24", "10.1.254.0/24", "10.1.253.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR ranges to create in VPC."
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "vpc_default_security_group_egress" {
  type        = list(map(string))
  description = "List of maps of egress rules to set on the default security group"
  default     = []
}

variable "vpc_default_security_group_ingress" {
  type        = list(map(string))
  description = "List of maps of ingress rules to set on the default security group"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of private subnet IDs that will be used by the route53 resolver endpoint. This is only used if `var.create_vpc` is false"
}

variable "vpc_endpoint_flags" {
  type = object({
    create_ec2         = optional(bool, true)
    create_ec2messages = optional(bool, true)
    create_kms         = optional(bool, true)
    create_s3          = optional(bool, true)
    create_ssm         = optional(bool, true)
    create_ssmmessages = optional(bool, true)
  })
  description = "Collection of flags to enable various VPC Endpoints"
  default     = {}
}

variable "vpc_option_flags" {
  type = object({
    create_igw                    = optional(bool, true)
    enable_dns_hostnames          = optional(bool, true)
    enable_dns_support            = optional(bool, true)
    enable_nat_gateway            = optional(bool, true)
    map_public_ip_on_launch       = optional(bool, true)
    manage_default_security_group = optional(bool, true)
    one_nat_gateway_per_az        = optional(bool, false)
    single_nat_gateway            = optional(bool, false)
  })
  description = "Object map of boolean flags to enable or disable certain features of the AWS VPC"
  default     = {}
}

#------------------------------------------------------------------------------
# LoadBalancing
#------------------------------------------------------------------------------
variable "route53_zone_name" {
  type        = string
  description = "Route 53 public zone name"
  default     = ""
}

variable "route53_record_health_check_enabled" {
  type        = bool
  description = "Enabled evaluation of target health for direct LB record"
  default     = false
}

variable "route53_private_zone" {
  type        = bool
  description = "Boolean that when true, designates the data lookup to use a private Route 53 zone name"
  default     = false
}

variable "route53_failover_record" {
  type = object({
    create              = optional(bool, true)
    set_id              = optional(string, "fso1")
    lb_failover_primary = optional(bool, true)
    record_name         = optional(string)
  })
  default     = {}
  description = "If set, creates a Route53 failover record.  Ensure that the record name is the same between both modules.  Also, the Record ID needs to be unique per module"
}

variable "lb_sg_rules_details" {
  type = object({
    consul_api_ingress = optional(object({
      type        = optional(string, "ingress")
      create      = optional(bool, true)
      from_port   = optional(string, "8500")
      to_port     = optional(string, "8500")
      protocol    = optional(string, "tcp")
      cidr_blocks = optional(list(string), [])
      description = optional(string, "Allow 8500 traffic inbound for Consul")
    }))
    consul_api_tls_ingress = optional(object({
      type        = optional(string, "ingress")
      create      = optional(bool, true)
      from_port   = optional(string, "8501")
      to_port     = optional(string, "8501")
      protocol    = optional(string, "tcp")
      cidr_blocks = optional(list(string), [])
      description = optional(string, "Allow 8501 traffic inbound for Consul")
    }))
    egress = optional(object({
      type        = optional(string, "egress")
      create      = optional(bool, true)
      from_port   = optional(string, "0")
      to_port     = optional(string, "0")
      protocol    = optional(string, "-1")
      cidr_blocks = optional(list(string), ["0.0.0.0/0"])
      description = optional(string, "Allow traffic outbound")
    }))
  })
  description = "Object map for various Security Group Rules as pertains to the Load Balancer for the installation"
  default = {
    consul_api_ingress     = {}
    consul_console_ingress = {}
    egress                 = {}
  }
}

variable "create_lb_certificate" {
  type        = bool
  default     = true
  description = "Boolean that when true will create the SSL certificate for the ALB to use."
}

variable "create_lb_security_groups" {
  type        = bool
  default     = true
  description = "Boolean that when true will create the required security groups for the load balancers to use."
}

variable "lb_name" {
  type        = string
  default     = "lb"
  description = "Name of the Load Balancer to be deployed"
}

variable "lb_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Optional list of security group IDs to be used if providing security groups created outside of this module"
}

variable "lb_internal" {
  type        = bool
  default     = false
  description = "Boolean to determine if the Load Balancer will be internal or internet facing"
}

variable "lb_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of Subnet IDs to deploy Load Balancer into"
}

variable "lb_type" {
  type        = string
  default     = "network"
  description = "Type of load balancer that will be provisioned as a part of the module execution (if specified)."
}

variable "lb_certificate_arn" {
  type        = string
  default     = null
  description = "Bring your own certificate ARN"
}

variable "lb_listener_details" {
  type = object({
    consul_dns = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 53)
      ssl_policy  = optional(string, "")
      action_type = optional(string, "forward")
    }))
    consul_mesh_gateway = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 443)
      ssl_policy  = optional(string, "")
      action_type = optional(string, "forward")
    }))
    consul_api = optional(object({
      create      = optional(bool, false)
      port        = optional(number, 8500)
      ssl_policy  = optional(string, "ELBSecurityPolicy-TLS-1-2-2017-01")
      action_type = optional(string, "forward")
    }))
    consul_api_tls = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 8501)
      ssl_policy  = optional(string, "ELBSecurityPolicy-TLS-1-2-2017-01")
      action_type = optional(string, "forward")
    }), {})
    consul_ingress_gateway = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 8080)
      ssl_policy  = optional(string, "")
      action_type = optional(string, "forward")
    }))
    consul_grpc_tls = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 8502)
      ssl_policy  = optional(string, "")
      action_type = optional(string, "forward")
    }))
  })
  description = "Configures the LB Listeners for various HashiCorp Products"
  default     = {}
}

variable "lb_target_groups" {
  type = object({
    consul_dns = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "consul-dns-tg")
      description          = optional(string, "Target Group for Consul DNS traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8600)
      protocol             = optional(string, "TCP_UDP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "8600")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }))
    }))
    consul_mesh_gateway = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "consul-mesh-gw-tg")
      description          = optional(string, "Target Group for Consul Mesh Gateway traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8443)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "8443")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }))
    }))
    consul_api = optional(object({
      create               = optional(bool, false)
      name                 = optional(string, "consul-api-tg")
      description          = optional(string, "Target Group for Consul api traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8500)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, false)
        port                = optional(string, "8500")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }))
    }))
    consul_api_tls = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "consul-api-tls-tg")
      description          = optional(string, "Target Group for Consul api traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8501)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "8501")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }), {})
    }), {})
    consul_grpc_tls = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "consul-grpc-tls-tg")
      description          = optional(string, "Target Group for Consul GRPC traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8500)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "8500")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }))
    }))
    consul_ingress_gateway = optional(object({
      create               = optional(bool, true)
      name                 = optional(string, "consul-ing-gw-tg")
      description          = optional(string, "Target Group for Consul Ingress Gateway traffic")
      deregistration_delay = optional(number, 15)
      port                 = optional(number, 8080)
      protocol             = optional(string, "TCP")
      health_check = optional(object({
        enabled             = optional(bool, true)
        port                = optional(string, "8080")
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 2)
        timeout             = optional(number, 5)
        interval            = optional(number, 10)
        matcher             = optional(string, "200-299")
        path                = optional(string, "")
        protocol            = optional(string, "TCP")
      }))
    }))
  })
  description = "Object map for the Load Balancer Target Group configuration"
  default     = {}
}

#------------------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------------------

variable "secretsmanager_secrets" {
  type = object({
    consul = optional(object({
      license = optional(object({
        name        = optional(string, "consul-license")
        description = optional(string, "Consul license")
        data        = optional(string, null)
        path        = optional(string, null)
      }))
      acl_token = optional(object({
        name        = optional(string, "consul-acl-token")
        description = optional(string, "Consul default ACL token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      agent_token = optional(object({
        name        = optional(string, "consul-agent-token")
        description = optional(string, "Consul agent token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      gossip_key = optional(object({
        name        = optional(string, "consul-gossip-key")
        description = optional(string, "Consul Gossip encryption key")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      snapshot_token = optional(object({
        name        = optional(string, "consul-snapshot-token")
        description = optional(string, "Consul Snapshot token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      replication_token = optional(object({
        name        = optional(string, "consul-replication-token")
        description = optional(string, "Consul Replication token")
        data        = optional(string, null)
        generate    = optional(bool, true)
      }))
      mesh_gw_token = optional(object({
        name        = optional(string, "consul-mesh-gw-token")
        description = optional(string, "Consul Mesh Gateway token")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      ingress_gw_token = optional(object({
        name        = optional(string, "consul-ingress-gw-token")
        description = optional(string, "Consul Ingress Gateway token")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      terminating_gw_token = optional(object({
        name        = optional(string, "consul-terminating-gw-token")
        description = optional(string, "Consul Terminating Gateway token")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
    }))
    ca_certificate_bundle = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO CA certificate bundle")
      data        = optional(string, null)
    }))
    cert_pem_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO PEM-encoded TLS certificate")
      data        = optional(string, null)
    }))
    cert_pem_private_key_secret = optional(object({
      name        = optional(string, null)
      path        = optional(string, null)
      description = optional(string, "BYO PEM-encoded TLS private key")
      data        = optional(string, null)
    }))
  })
  description = "Object Map that contains various secrets that will be created and stored in AWS Secrets Manager."
  default     = {}
}

variable "optional_secrets" {
  type        = map(any)
  default     = {}
  description = <<DESC
  Optional variable that when supplied will be merged with the `secretsmanager_secrets` map. These secrets need to have the following specification:
  optional_secrets = {
    secret_1 = {
      name = "supesecret"
      description = "it's my secret that is important"
      path = "path to file if you are using one"
      data = "string data if you are supplying it"
    }
    secret_2 = {
      name = "supesecret2"
      description = "it's my secret that is also important probably"
      path = "path to file if you are using one"
      data = "string data if you are supplying it"
    }
  }
  DESC
}

#------------------------------------------------------------------------------
# S3
#------------------------------------------------------------------------------

variable "s3_buckets" {
  type = object({
    snapshot = optional(object({
      create                              = optional(bool, true)
      bucket_name                         = optional(string, "consul-snapshot-bucket")
      description                         = optional(string, "Storage location for HashiCorp snapshots that will be exported")
      versioning                          = optional(bool, true)
      force_destroy                       = optional(bool, false)
      replication                         = optional(bool, false)
      replication_destination_bucket_arn  = optional(string)
      replication_destination_kms_key_arn = optional(string)
      replication_destination_region      = optional(string)
      encrypt                             = optional(bool, true)
      bucket_key_enabled                  = optional(bool, true)
      kms_key_arn                         = optional(string)
      sse_s3_managed_key                  = optional(bool, false)
    }))
  })
  description = "Object Map that contains the configuration for the S3 bucket configuration used in the installers."
  default     = {}
}


#------------------------------------------------------------------------------
# Logging
#------------------------------------------------------------------------------
variable "log_group_name" {
  type        = string
  description = "Name of the Cloud Watch Log Group to be used for Consul logs."
  default     = "consul-log-group"
}

variable "cloudwatch_kms_key_arn" {
  type        = string
  description = "KMS key that cloudwatch will use. If not specified, the kms key that is created will be used."
  default     = null
}

variable "log_group_retention_days" {
  type        = number
  description = "Number of days to retain logs in Log Group."
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 180, 365, 400, 545, 731, 1827, 3653], var.log_group_retention_days)
    error_message = "Supported values are `1`, `3`, `5`, `7`, `14`, `30`, `60`, `90`, `120`, `150`, `180`, `365`, `400`, `545`, `731`, `1827`, `3653`."
  }
}

#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------
variable "iam_resources" {
  type = object({
    bucket_arns             = optional(list(string), [])
    kms_key_arns            = optional(list(string), [])
    secret_manager_arns     = optional(list(string), [])
    log_group_arn           = optional(string, "")
    log_forwarding_enabled  = optional(bool, true)
    role_name               = optional(string, "deployment-role")
    policy_name             = optional(string, "deployment-policy")
    ssm_enable              = optional(bool, false)
    custom_tbw_ecr_repo_arn = optional(string, "")
  })
  description = "A list of objects for to be referenced in an IAM policy for the instance.  Each is a list of strings that reference infra related to the install"
}

variable "create_asg_service_iam_role" {
  type        = bool
  description = "Boolean to create a service linked role for AWS Auto Scaling.  This is required to be created prior to the KMS Key Policy.  This may or may not exist in an AWS Account and needs to be explicilty determined"
  default     = false
}

variable "asg_service_iam_role_custom_suffix" {
  type        = string
  description = "Custom suffix for the AWS Service Linked Role.  AWS IAM only allows unique names.  Leave blank with create_asg_service_iam_role to create the Default Service Linked Role, or add a value to create a secondary role for use with this module"
  default     = ""
}

#------------------------------------------------------------------------------
# Consul Key Pair
#------------------------------------------------------------------------------

variable "ssh_public_key" {
  type        = string
  description = "Public key material for SSH Key Pair."
  default     = null
}

variable "ssh_keypair_name" {
  type        = string
  description = "Name of the keypair that will be created or used (if it already exists)."
  default     = "consul-keypair"
}

variable "security_group_rules" {
  type = object({
    consul = optional(object({
      server = optional(object({
        rpc = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8300)
          to_port      = optional(number, 8300)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Server ingress RPC traffic")
          self         = optional(bool, true)
          target_sg    = optional(string, "agent")
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        serf_lan_tcp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8301)
          to_port      = optional(number, 8302)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Server TCP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string, "agent")
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        serf_lan_udp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8301)
          to_port      = optional(number, 8302)
          protocol     = optional(string, "udp")
          description  = optional(string, "Consul Server UDP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string, "agent")
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        dns_tcp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8600)
          to_port      = optional(number, 8600)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Server TCP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, true)
        }), {})
        dns_udp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8600)
          to_port      = optional(number, 8600)
          protocol     = optional(string, "udp")
          description  = optional(string, "Consul Server UDP DNS traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, true)
        }), {})
        https_api = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8501)
          to_port      = optional(number, 8501)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul server HTTPS api traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        http_api = optional(object({
          enabled      = optional(bool, false)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8500)
          to_port      = optional(number, 8500)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul server HTTP api traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        grpc = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8502)
          to_port      = optional(number, 8502)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul server HTTPS api traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        grpc_tls = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8503)
          to_port      = optional(number, 8503)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul server HTTPS api traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
      }), {})
      agent = optional(object({
        rpc = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "egress")
          from_port    = optional(number, 8300)
          to_port      = optional(number, 8300)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul agent egress RPC traffic")
          self         = optional(bool, true)
          target_sg    = optional(string, "server")
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        serf_lan_tcp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8301)
          to_port      = optional(number, 8302)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Server TCP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        serf_lan_udp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8301)
          to_port      = optional(number, 8302)
          protocol     = optional(string, "udp")
          description  = optional(string, "Consul Server UDP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, true)
        }), {})
        dns_tcp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8600)
          to_port      = optional(number, 8600)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Server TCP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, true)
        }), {})
        dns_udp = optional(object({
          enabled      = optional(bool, true)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8600)
          to_port      = optional(number, 8600)
          protocol     = optional(string, "udp")
          description  = optional(string, "Consul Server TCP Serf traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
      }), {})
      gateway = optional(object({
        mesh_gateway = optional(object({
          enabled      = optional(bool, false)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8443)
          to_port      = optional(number, 8443)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Mesh Gateway traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
        ingress_gateway = optional(object({
          enabled      = optional(bool, false)
          type         = optional(string, "ingress")
          from_port    = optional(number, 8080)
          to_port      = optional(number, 8080)
          protocol     = optional(string, "tcp")
          description  = optional(string, "Consul Ingress Gateway traffic")
          self         = optional(bool, true)
          target_sg    = optional(string)
          cidr_blocks  = optional(list(string))
          bidrectional = optional(bool, false)
        }), {})
      }))
    }), {})
  })
  description = "Object Map that contains various configurations for the HashiCorp Product systems which when configured, will be deployed."
  default     = {}
}

variable "create_security_groups" {
  type        = bool
  description = "Boolean that when true will create the required security groups for the product you are deploying"
  default     = true
}

variable "route53_resolver_pool" {
  type = object({
    enabled       = optional(bool, false)
    consul_domain = optional(string, "dc1.consul")
  })
  default     = {}
  description = <<DESC
  "Object map that contains the Route53 resolver pool configuration that will be used when creating the endpoints.
  \'consul_domain\' is utilized for the route53 resolver domain and defaults to `dc1.consul`. Please adjust this domain if you are using a different datacenter or custom domain for Consul.
  "
  DESC
}