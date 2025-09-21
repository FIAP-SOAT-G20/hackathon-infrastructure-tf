data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.project_name}-${var.environment}-user-service"
  retention_in_days = var.log_retention_days

  tags = var.common_tags
}

# Lambda Function
resource "aws_lambda_function" "user_service" {
  package_type  = "Image"
  image_uri     = var.lambda_image_uri
  function_name = "${var.project_name}-${var.environment}-user-service"
  role          = data.aws_iam_role.lab_role.arn
  memory_size   = var.lambda_memory
  timeout       = var.lambda_timeout



  environment {
    variables = merge(var.environment_variables, {
      USERS_TABLE_NAME            = var.users_table_name
      IDS_TABLE_NAME              = var.ids_table_name
      JWT_SECRET_PARAMETER_NAME   = var.jwt_secret_parameter_name
      JWT_EXPIRATION_PARAMETER_NAME = var.jwt_expiration_parameter_name
    })
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]

  tags = var.common_tags
}