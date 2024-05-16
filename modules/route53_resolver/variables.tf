#------------------------------------------------------------------------------
# Common
#------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "String value for friendly name prefix for AWS resource names."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for taggable AWS resources."
  default     = {}
}

variable "product" {
  type        = string
  description = "Name of the HashiCorp product that will be installed (tfe, vault, consul)"
  validation {
    condition     = contains(["tfe", "vault", "consul"], var.product)
    error_message = "`var.product` must be \"tfe\", \"vault\", or \"consul\"."
  }
  default = "consul"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of subnet-ids associated with the internal NLB."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID that will be used by the workloads."
}

variable "route53_resolver_pool" {
  type = object({
    enabled       = optional(bool, true)
    consul_domain = optional(string, "dc1.consul")
    lb_arn_suffix = optional(string, null)
  })
  default     = {}
  description = <<DESC
  "Object map that contains the Route53 resolver pool configuration that will be used when creating the endpoints.
  \'lb_arn_suffix\' is required.
  \'consul_domain\' is utilized for the route53 resolver domain and defaults to `dc1.consul`. Please adjust this domain if you are using a different datacenter or custom domain for Consul.
  "
  DESC
}