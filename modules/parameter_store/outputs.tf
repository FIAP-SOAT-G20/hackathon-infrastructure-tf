output "jwt_secret_parameter_name" {
  description = "Name of the JWT secret parameter"
  value       = aws_ssm_parameter.jwt_secret.name
}

output "jwt_secret_parameter_arn" {
  description = "ARN of the JWT secret parameter"
  value       = aws_ssm_parameter.jwt_secret.arn
}

output "jwt_expiration_parameter_name" {
  description = "Name of the JWT expiration parameter"
  value       = aws_ssm_parameter.jwt_expiration.name
}

output "jwt_expiration_parameter_arn" {
  description = "ARN of the JWT expiration parameter"
  value       = aws_ssm_parameter.jwt_expiration.arn
}