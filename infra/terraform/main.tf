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

resource "aws_s3_bucket" "media" {
  bucket = "${local.project}-media"

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}

resource "aws_dynamodb_table" "pages" {
  name         = "${local.project}-pages"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "page_id"

  attribute {
    name = "page_id"
    type = "S"
  }

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}

resource "aws_dynamodb_table" "news" {
  name         = "${local.project}-news"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "news_id"

  attribute {
    name = "news_id"
    type = "S"
  }

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}