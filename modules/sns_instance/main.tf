resource "aws_sns_topic" "this" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_policy" "this" {
  arn = aws_sns_topic.this.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowPublish",
      Effect    = "Allow",
      Principal = "*",
      Action    = "SNS:Publish",
      Resource  = aws_sns_topic.this.arn
    }]
  })
}

resource "aws_sns_topic_subscription" "https" {
  topic_arn                   = aws_sns_topic.this.arn
  protocol                    = "https"
  endpoint                    = var.sns_https_endpoint
  endpoint_auto_confirms      = true
  confirmation_timeout_in_minutes = 5
  raw_message_delivery        = false
}
