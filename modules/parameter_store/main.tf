# JWT Secret Parameter
resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/${var.project_name}/${var.environment}/jwt/secret"
  type  = "SecureString"
  value = var.jwt_secret

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-jwt-secret"
    Service     = "parameter-store"
    Description = "JWT secret for token signing"
  })
}

# JWT Expiration Parameter
resource "aws_ssm_parameter" "jwt_expiration" {
  name  = "/${var.project_name}/${var.environment}/jwt/expiration"
  type  = "String"
  value = var.jwt_expiration

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-jwt-expiration"
    Service     = "parameter-store"
    Description = "JWT token expiration duration"
  })
}