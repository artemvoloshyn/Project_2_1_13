output "frontend_alb_dns" {
  value = aws_lb.frontend_alb.dns_name
}

output "frontend_alb_arn" {
  value = aws_lb.frontend_alb.arn
}

