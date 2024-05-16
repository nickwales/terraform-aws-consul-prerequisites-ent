# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">=1.5.0"
  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = ">= 2.18.0"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = ">=1.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
}