variable "region" {
  type        = string
  description = "AWS Region"
}


variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name prefix used for tagging and naming AWS resources."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for all taggable AWS resources."
  default     = {}
}

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
        description = optional(string, "Consul gossip encryption key")
        data        = optional(string, null)
        generate    = optional(bool, false)
      }))
      terminating_gw_token = optional(object({
        name        = optional(string, "consul-terminating-gw-token")
        description = optional(string, "Consul Terminating Gateway key")
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

variable "s3_buckets" {
  type = object({
    snapshot = optional(object({
      create                              = optional(bool, true)
      bucket_name                         = optional(string, "vault-snapshot-bucket")
      description                         = optional(string, "Storage location for Vault snapshots that will be exported")
      versioning                          = optional(bool, true)
      force_destroy                       = optional(bool, false)
      replication                         = optional(bool, false)
      replication_destination_bucket_arn  = optional(string)
      replication_destination_kms_key_arn = optional(string)
      encrypt                             = optional(bool, true)
      bucket_key_enabled                  = optional(bool, true)
      kms_key_arn                         = optional(string)
    }), {})
  })
  description = "Object Map that contains the configuration for the S3 bucket configuration used in the installers."
  default     = {}
}

variable "route53_zone_name" {
  type        = string
  description = "Route 53 public zone name"
  default     = ""
}

variable "ssh_public_key" {
  type        = string
  description = "Public key material for SSH Key Pair."
  default     = null
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
    role_name               = optional(string, "consul-role")
    policy_name             = optional(string, "consul-policy")
    ssm_enable              = optional(bool, false)
    cloud_auto_join_enabled = optional(bool, true)
  })
  default     = {}
  description = "A list of objects for to be referenced in an IAM policy for the instance.  Each is a list of strings that reference infra related to the install"
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
      }), {})
    }), {})
  })
  description = "Object Map that contains various configurations for the HashiCorp Product systems which when configured, will be deployed."
  default     = {}
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

variable "lb_listener_details" {
  type = object({
    consul_dns = optional(object({
      create      = optional(bool, true)
      port        = optional(number, 53)
      ssl_policy  = optional(string, "")
      action_type = optional(string, "forward")
    }), {})
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
    }), {})
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

variable "lb_type" {
  type        = string
  default     = "network"
  description = "Type of load balancer that will be provisioned as a part of the module execution (if specified)."
}


variable "consul_server_agent" {
  type = object({
    container_image               = optional(string, "hashicorp/consul-enterprise:1.16.0-ent")
    server                        = optional(bool, true)
    domain                        = optional(string, "consul")
    datacenter                    = optional(string, "dc1")
    primary_datacenter            = optional(string, "dc1")
    join_environment              = optional(string, "primary")
    ui                            = optional(bool, false)
    log_level                     = optional(string, "INFO")
    partition                     = optional(string, "")
    auto_reload_config            = optional(bool, true)
    enable_central_service_config = optional(bool, true)
    enable_grpc                   = optional(bool, false)
  })
  description = "Object map that contains the configuration for the Consul agent that will be deployed on the workloads within the environment."
}

variable "consul_agent" {
  type = object({
    container_image               = optional(string, "hashicorp/consul-enterprise:1.16.0-ent")
    server                        = optional(bool, false)
    domain                        = optional(string, "consul")
    datacenter                    = optional(string, "dc1")
    primary_datacenter            = optional(string, "dc1")
    join_environment              = optional(string, "primary")
    ui                            = optional(bool, false)
    log_level                     = optional(string, "INFO")
    partition                     = optional(string, "")
    auto_reload_config            = optional(bool, true)
    enable_central_service_config = optional(bool, true)
    enable_grpc                   = optional(bool, false)
  })
  description = "Object map that contains the configuration for the Consul agent that will be deployed on the workloads within the environment."
}


variable "snapshot_agent" {
  type = object({
    enabled        = optional(bool, false)
    interval       = optional(string, "")
    retention      = optional(number, 0)
    s3_bucket_name = optional(string, "")
  })
  description = "Configuration object to enable the Consul snapshot agent."
  default     = {}
}

variable "consul_server_cluster_version" {
  type        = string
  description = "SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config)"
}

variable "consul_server_environment_name" {
  type        = string
  description = "Unique environment name to prefix and disambiguate resources using."
}

variable "log_forwarding_enabled" {
  type        = bool
  description = "Boolean that when true, will enable log forwarding to Cloud Watch"
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

variable "lb_internal" {
  type        = bool
  default     = false
  description = "Boolean to determine if the Load Balancer will be internal or internet facing"
}

variable "consul_agent_cluster_version" {
  type        = string
  description = "SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config)"
}

variable "consul_agent_environment_name" {
  type        = string
  description = "Unique environment name to prefix and disambiguate resources using."
}

variable "consul_gateway_cluster_version" {
  type        = string
  description = "SemVer version string representing the cluster's deployent iteration. Must always be incremented when deploying updates (e.g. new AMIs, updated launch config)"
}

variable "consul_gateway_environment_name" {
  type        = string
  description = "Unique environment name to prefix and disambiguate resources using."
}

variable "ingress_gateway" {
  type = object({
    enabled         = optional(bool, false)
    container_image = optional(string, "")
    service_name    = optional(string, "")
    listener_ports  = optional(list(number), [])
    ingress_cidrs   = optional(list(string), [])
  })
  default     = {}
  description = "Configuration object to deploy a Consul ingress gateway."
}
