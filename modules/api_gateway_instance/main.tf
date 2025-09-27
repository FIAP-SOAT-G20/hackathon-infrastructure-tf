# API Gateway REST API
resource "aws_api_gateway_rest_api" "hackathon_api" {
  name        = "${var.project_name}-${var.environment}-api"
  description = "API Gateway for Hackathon Services"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(var.common_tags, {
    Name    = "${var.project_name}-${var.environment}-api"
    Service = "hackathon-api"
  })
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "hackathon_deployment" {
  depends_on = [
    aws_api_gateway_integration.users_integration,
    aws_api_gateway_integration.users_register_integration,
    aws_api_gateway_integration.users_login_integration,
    aws_api_gateway_integration.users_me_integration,
    aws_api_gateway_integration.videos_any_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users_resource.id,
      aws_api_gateway_resource.register_resource.id,
      aws_api_gateway_resource.login_resource.id,
      aws_api_gateway_resource.me_resource.id,
      aws_api_gateway_resource.videos_resource.id,
      aws_api_gateway_method.register_post.id,
      aws_api_gateway_method.login_post.id,
      aws_api_gateway_method.me_get.id,
      aws_api_gateway_method.videos_any.id,
      aws_api_gateway_integration.users_register_integration.id,
      aws_api_gateway_integration.users_login_integration.id,
      aws_api_gateway_integration.users_me_integration.id,
      aws_api_gateway_integration.videos_any_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "hackathon_stage" {
  deployment_id = aws_api_gateway_deployment.hackathon_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  stage_name    = var.stage_name

  tags = merge(var.common_tags, {
    Name    = "${var.project_name}-${var.environment}-api-${var.stage_name}"
    Service = "hackathon-api"
  })
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "users_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hackathon_api.execution_arn}/*/*"
}


# Resources and Methods
resource "aws_api_gateway_resource" "users_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_rest_api.hackathon_api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "videos_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_rest_api.hackathon_api.root_resource_id
  path_part   = "videos"
}

resource "aws_api_gateway_resource" "videos_manager_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_rest_api.hackathon_api.root_resource_id
  path_part   = "videos-manager"
}

resource "aws_api_gateway_resource" "video_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.videos_resource.id
  path_part   = "{proxy+}"
}


resource "aws_api_gateway_resource" "register_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "register"
}

resource "aws_api_gateway_resource" "login_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "me_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "me"
}

# POST /users/register
resource "aws_api_gateway_method" "register_post" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.register_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_register_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.register_resource.id
  http_method = aws_api_gateway_method.register_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# POST /users/login
resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.login_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_login_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.login_resource.id
  http_method = aws_api_gateway_method.login_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# GET /users/me
resource "aws_api_gateway_method" "me_get" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.me_resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Authorization" = true
  }
}

resource "aws_api_gateway_method" "videos_manager_any" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.videos_manager_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_me_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.me_resource.id
  http_method = aws_api_gateway_method.me_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Catch-all integration for root /users path
resource "aws_api_gateway_method" "users_any" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.users_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.users_resource.id
  http_method = aws_api_gateway_method.users_any.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Video method
resource "aws_api_gateway_method" "videos_any" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Video integrations
resource "aws_api_gateway_integration" "videos_any_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_proxy_resource.id
  http_method = aws_api_gateway_method.videos_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos"
}

# Video Manager integrations
resource "aws_api_gateway_integration" "video_manager_any_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_proxy_resource.id
  http_method = aws_api_gateway_method.videos_manager_any.http_method

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/web"
}


# CORS configuration
resource "aws_api_gateway_method" "register_options" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.register_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "register_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.register_resource.id
  http_method = aws_api_gateway_method.register_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "register_options_response" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.register_resource.id
  http_method = aws_api_gateway_method.register_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "register_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.register_resource.id
  http_method = aws_api_gateway_method.register_options.http_method
  status_code = aws_api_gateway_method_response.register_options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}