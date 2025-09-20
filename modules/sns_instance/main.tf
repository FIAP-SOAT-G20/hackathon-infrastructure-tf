resource "aws_sns_topic" "topics" {
  for_each = var.topic_names

  name = each.value.name

  tags = merge({
    Environment = var.environment
    Name        = each.value.name
  }, lookup(each.value, "tags", {}))
}

