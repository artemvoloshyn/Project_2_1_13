output "frontend_alb_dns" {
  value = aws_lb.frontend_alb.dns_name
}

output "frontend_alb_arn" {
  value = aws_lb.frontend_alb.arn
}

output "frontend_alb_target_group_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}

