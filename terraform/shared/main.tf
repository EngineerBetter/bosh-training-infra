provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "bosh-training"
      Environment = "bosh-training"
    }
  }
}
