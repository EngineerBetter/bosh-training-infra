provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "bosh-training-marcus"
      Environment = "bosh-training-marcus"
    }
  }
}
