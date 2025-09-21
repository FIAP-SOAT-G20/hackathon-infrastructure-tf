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
    aws_api_gateway_integration.videos_get_integration,
    aws_api_gateway_integration.videos_post_integration,
    aws_api_gateway_integration.video_id_get_integration,
    aws_api_gateway_integration.video_id_put_integration,
    aws_api_gateway_integration.video_id_patch_integration,
    aws_api_gateway_integration.video_id_delete_integration,
    aws_api_gateway_integration.video_processed_get_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users_resource.id,
      aws_api_gateway_resource.register_resource.id,
      aws_api_gateway_resource.login_resource.id,
      aws_api_gateway_resource.me_resource.id,
      aws_api_gateway_resource.videos_resource.id,
      aws_api_gateway_resource.video_id_resource.id,
      aws_api_gateway_resource.video_processed_resource.id,
      aws_api_gateway_method.register_post.id,
      aws_api_gateway_method.login_post.id,
      aws_api_gateway_method.me_get.id,
      aws_api_gateway_method.videos_get.id,
      aws_api_gateway_method.videos_post.id,
      aws_api_gateway_method.video_id_get.id,
      aws_api_gateway_method.video_id_put.id,
      aws_api_gateway_method.video_id_patch.id,
      aws_api_gateway_method.video_id_delete.id,
      aws_api_gateway_method.video_processed_get.id,
      aws_api_gateway_integration.users_register_integration.id,
      aws_api_gateway_integration.users_login_integration.id,
      aws_api_gateway_integration.users_me_integration.id,
      aws_api_gateway_integration.videos_get_integration.id,
      aws_api_gateway_integration.videos_post_integration.id,
      aws_api_gateway_integration.video_id_get_integration.id,
      aws_api_gateway_integration.video_id_put_integration.id,
      aws_api_gateway_integration.video_id_patch_integration.id,
      aws_api_gateway_integration.video_id_delete_integration.id,
      aws_api_gateway_integration.video_processed_get_integration.id,
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

resource "aws_api_gateway_resource" "video_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.videos_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_resource" "video_processed_resource" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  parent_id   = aws_api_gateway_resource.video_id_resource.id
  path_part   = "processed"
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

# Video integrations
resource "aws_api_gateway_integration" "videos_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.videos_resource.id
  http_method = aws_api_gateway_method.videos_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos"

  request_parameters = {
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "videos_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.videos_resource.id
  http_method = aws_api_gateway_method.videos_post.http_method

  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos"

  request_parameters = {
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "video_id_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_id_resource.id
  http_method = aws_api_gateway_method.video_id_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "video_id_put_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_id_resource.id
  http_method = aws_api_gateway_method.video_id_put.http_method

  integration_http_method = "PUT"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "video_id_patch_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_id_resource.id
  http_method = aws_api_gateway_method.video_id_patch.http_method

  integration_http_method = "PATCH"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "video_id_delete_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_id_resource.id
  http_method = aws_api_gateway_method.video_id_delete.http_method

  integration_http_method = "DELETE"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos/{id}"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_api_gateway_integration" "video_processed_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.hackathon_api.id
  resource_id = aws_api_gateway_resource.video_processed_resource.id
  http_method = aws_api_gateway_method.video_processed_get.http_method

  integration_http_method = "GET"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.video_service_alb_dns}/videos/{id}/processed"

  request_parameters = {
    "integration.request.path.id" = "method.request.path.id"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

# Videos methods
resource "aws_api_gateway_method" "videos_get" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.videos_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "videos_post" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.videos_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "video_id_get" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_id_resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "video_id_put" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_id_resource.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "video_id_patch" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_id_resource.id
  http_method   = "PATCH"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "video_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_id_resource.id
  http_method   = "DELETE"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
}

resource "aws_api_gateway_method" "video_processed_get" {
  rest_api_id   = aws_api_gateway_rest_api.hackathon_api.id
  resource_id   = aws_api_gateway_resource.video_processed_resource.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = true
  }
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