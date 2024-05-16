variable "product" {
  type        = string
  description = "Name of the HashiCorp product that will be installed (tfe, tfefdo, vault, consul, boundary)"
  validation {
    condition     = contains(["tfe", "tfefdo", "vault", "consul", "boundary"], var.product)
    error_message = "`var.product` must be \"tfe\", \"tfefdo\", \"vault\", \"consul\", or \"boundary\"."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for taggable AWS resources."
  default     = {}
}

variable "friendly_name_prefix" {
  type        = string
  description = "String value for friendly name prefix for AWS resource names."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID that will be used by the workloads."
}

variable "security_group_rules" {
  type = object({
    consul = optional(object({
      server = optional(object({
        rpc = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8300)
          to_port       = optional(number, 8300)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Server ingress RPC traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }), {})
        serf_lan_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8301)
          to_port       = optional(number, 8302)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Server TCP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }), {})
        serf_lan_udp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8301)
          to_port       = optional(number, 8302)
          protocol      = optional(string, "udp")
          description   = optional(string, "Consul Server UDP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }))
        dns_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8600)
          to_port       = optional(number, 8600)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Server TCP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }))
        dns_udp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8600)
          to_port       = optional(number, 8600)
          protocol      = optional(string, "udp")
          description   = optional(string, "Consul Server UDP DNS traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }))
        https_api = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8501)
          to_port       = optional(number, 8501)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul server HTTPS api traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        http_api = optional(object({
          enabled       = optional(bool, false)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8500)
          to_port       = optional(number, 8500)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul server HTTP api traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        grpc = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8502)
          to_port       = optional(number, 8502)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul server HTTPS api traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        grpc_tls = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8503)
          to_port       = optional(number, 8503)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul server HTTPS api traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
      }), {})
      agent = optional(object({
        rpc = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "egress")
          from_port     = optional(number, 8300)
          to_port       = optional(number, 8300)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul agent egress RPC traffic")
          self          = optional(bool, true)
          target_sg     = optional(string, "server")
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }), {})
        serf_lan_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8301)
          to_port       = optional(number, 8302)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Server TCP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        serf_lan_udp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8301)
          to_port       = optional(number, 8302)
          protocol      = optional(string, "udp")
          description   = optional(string, "Consul Server UDP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }))
        dns_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8600)
          to_port       = optional(number, 8600)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Server TCP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, true)
        }))
        dns_udp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8600)
          to_port       = optional(number, 8600)
          protocol      = optional(string, "udp")
          description   = optional(string, "Consul Server TCP Serf traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
      }))
      gateway = optional(object({
        mesh_gateway = optional(object({
          enabled       = optional(bool, false)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8443)
          to_port       = optional(number, 8443)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Mesh Gateway traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        ingress_gateway = optional(object({
          enabled       = optional(bool, false)
          type          = optional(string, "ingress")
          from_port     = optional(number, 8080)
          to_port       = optional(number, 8080)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Consul Ingress Gateway traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
      }))
    }), {})
    tfe    = optional(object({}))
    tfefdo = optional(object({}))
    vault  = optional(object({}))
    boundary = optional(object({
      controller = optional(object({
        ssh = optional(object({
          enabled       = optional(bool, false)
          type          = optional(string, "ingress")
          from_port     = optional(number, 22)
          to_port       = optional(number, 22)
          protocol      = optional(string, "tcp")
          description   = optional(string, "SSH Traffic to Controller")
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        api_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 9200)
          to_port       = optional(number, 9200)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Boundary API traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        cluster_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 9201)
          to_port       = optional(number, 9201)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Boundary cluster traffic from workers")
          self          = optional(bool, false)
          target_sg     = optional(string, "worker")
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
      }))
      worker = optional(object({
        proxy_tcp = optional(object({
          enabled       = optional(bool, true)
          type          = optional(string, "ingress")
          from_port     = optional(number, 9202)
          to_port       = optional(number, 9202)
          protocol      = optional(string, "tcp")
          description   = optional(string, "Worker proxy traffic")
          self          = optional(bool, true)
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
        ssh = optional(object({
          enabled       = optional(bool, false)
          type          = optional(string, "ingress")
          from_port     = optional(number, 22)
          to_port       = optional(number, 22)
          protocol      = optional(string, "tcp")
          description   = optional(string, "SSH Traffic to Worker")
          target_sg     = optional(string)
          cidr_blocks   = optional(list(string))
          bidirectional = optional(bool, false)
        }))
      }))
    }))
  })
  description = "Object Map that contains various configurations for the HashiCorp Product systems which when configured, will be deployed."
}


variable "permit_all_egress" {
  type        = bool
  default     = true
  description = "Whether broad (0.0.0.0/0) egress should be permitted on cluster nodes. If disabled, additional rules must be added to permit HTTP(S) and other necessary network access."
}
