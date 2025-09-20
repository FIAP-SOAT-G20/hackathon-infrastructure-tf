output "rds_postgres_hackathon_endpoint" {
  description = "DNS endpoint of the hackathon RDS instance"
  value       = aws_db_instance.postgres_hackathon.address
}

output "rds_postgres_hackathon_db_name" {
  description = "Database name of the hackathon RDS instance"
  value       = aws_db_instance.postgres_hackathon.db_name
}
