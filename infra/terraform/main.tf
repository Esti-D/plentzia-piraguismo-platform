# Base Terraform configuration
# Resources will be added incrementally as infrastructure is implemented

locals {
  project = "plentzia-piraguismo-platform"
  environment = "dev"
}

resource "aws_s3_bucket" "public_web" {
  bucket = "${local.project}-public-web"

  tags = {
    Project = local.project
    Environment = local.environment
  }
}