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

resource "aws_s3_bucket" "admin_web" {
  bucket = "${local.project}-admin-web"

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

resource "aws_cloudfront_distribution" "public_web" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.public_web.bucket_regional_domain_name
    origin_id   = "public-web-s3"

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    target_origin_id       = "public-web-s3"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}

resource "aws_cloudfront_distribution" "admin_web" {
  enabled = true

  origin {
    domain_name = aws_s3_bucket.admin_web.bucket_regional_domain_name
    origin_id   = "admin-web-s3"

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    target_origin_id       = "admin-web-s3"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
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

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${local.project}-api"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"

  integration_uri  = aws_lambda_function.api.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "health" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /health"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_cognito_user_pool" "admin_users" {
  name = "${local.project}-admins"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 8
  }

  tags = {
    Project     = local.project
    Environment = local.environment
  }
}

resource "aws_cognito_user_pool_client" "admin_client" {
  name         = "${local.project}-admin-client"
  user_pool_id = aws_cognito_user_pool.admin_users.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]

  callback_urls = [
    "http://localhost"
  ]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "admin_domain" {
  domain       = "${local.project}-auth"
  user_pool_id = aws_cognito_user_pool.admin_users.id
}

resource "aws_apigatewayv2_authorizer" "cognito" {
  name             = "${local.project}-authorizer"
  api_id           = aws_apigatewayv2_api.http_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.admin_client.id]
    issuer   = "https://cognito-idp.eu-west-1.amazonaws.com/${aws_cognito_user_pool.admin_users.id}"
  }
}

resource "aws_cognito_user" "admin_user" {
  user_pool_id = aws_cognito_user_pool.admin_users.id
  username     = "admin"

  attributes = {
    email          = "admin@club.com"
    email_verified = "true"
  }

  temporary_password = "TempPassword123!"
}

resource "aws_apigatewayv2_route" "admin_test" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /admin"

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito.id
}


output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "cloudfront_public_url" {
  value = aws_cloudfront_distribution.public_web.domain_name
}

output "cloudfront_admin_url" {
  value = aws_cloudfront_distribution.admin_web.domain_name
}

