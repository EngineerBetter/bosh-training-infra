provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "bosh-training"
      Environment = "bosh-training"
    }
  }
}

terraform {
  backend "s3" {}

  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
