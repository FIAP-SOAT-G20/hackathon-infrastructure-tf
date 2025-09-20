output "alb_dns_name" {
  value = aws_lb.aws_alb_instance.dns_name
}

output "alb_arn" {
  value = aws_lb.aws_alb_instance.arn
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
