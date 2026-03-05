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

resource "aws_iam_role" "lambda_role" {
  name = "${local.project}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "api" {
  function_name = "${local.project}-api"

  filename      = "../lambda/api.zip"
  handler       = "health.handler"
  runtime       = "nodejs18.x"

  role = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64sha256("../lambda/api.zip")

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}