resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  tags = merge({
    Environment = var.environment
    Name        = var.s3_bucket_name
  }, var.common_tags)
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket     = aws_s3_bucket.bucket.id
  depends_on = [var.sqs_queue_policy_dependency]

  queue {
    queue_arn = var.sqs_queue_arn
    filter_prefix = "raw/"
    events    = ["s3:ObjectCreated:*"]
  }
}
