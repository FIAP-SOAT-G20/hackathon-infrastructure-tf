output "sns_topic_arns" {
  description = "Map of SNS topic names to their ARNs"
  value = {
    for key, topic in aws_sns_topic.topics :
    key => topic.arn
  }
}