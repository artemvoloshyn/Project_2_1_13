output "aws_rds_postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint

}

output "aws_rds_postgres_port" {
  value = aws_db_instance.postgres.port

}
