# Users table
resource "aws_dynamodb_table" "users" {
  name           = "${var.project_name}-${var.environment}-users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userId"

  attribute {
    name = "userId"
    type = "N"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name     = "email_index"
    hash_key = "email"
    projection_type = "ALL"
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-users"
    Purpose     = "User data storage for hackathon user service"
    Service     = "user-service"
  })
}

# IDs sequence table
resource "aws_dynamodb_table" "ids" {
  name           = "${var.project_name}-${var.environment}-ids"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "sequence"

  attribute {
    name = "sequence"
    type = "S"
  }

  tags = merge(var.common_tags, {
    Name        = "${var.project_name}-${var.environment}-ids"
    Purpose     = "ID sequence generation for hackathon user service"
    Service     = "user-service"
  })
}

# Initialize the user ID sequence
resource "aws_dynamodb_table_item" "user_id_sequence" {
  table_name = aws_dynamodb_table.ids.name
  hash_key   = aws_dynamodb_table.ids.hash_key

  item = jsonencode({
    sequence = {
      S = "user_id"
    }
    current_id = {
      N = "0"
    }
  })

  depends_on = [aws_dynamodb_table.ids]
}