output "users_table_name" {
  description = "Name of the users DynamoDB table"
  value       = aws_dynamodb_table.users.name
}

output "users_table_arn" {
  description = "ARN of the users DynamoDB table"
  value       = aws_dynamodb_table.users.arn
}

output "ids_table_name" {
  description = "Name of the IDs DynamoDB table"
  value       = aws_dynamodb_table.ids.name
}

output "ids_table_arn" {
  description = "ARN of the IDs DynamoDB table"
  value       = aws_dynamodb_table.ids.arn
}