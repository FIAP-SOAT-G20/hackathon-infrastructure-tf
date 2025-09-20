resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  tags = merge({
    Environment = var.environment
    Name        = var.s3_bucket_name
  }, var.common_tags)
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket   = aws_s3_bucket.bucket.id

  queue {
    queue_arn = var.sqs_queue_arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sqs_queue_policy" "s3_to_sqs" {
  queue_url = var.sqs_queue_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ToSendMessage"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = var.sqs_queue_arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_s3_bucket.bucket.arn
          }
        }
      }
    ]
  })
}
