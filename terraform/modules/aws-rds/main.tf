resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.private_subnet_id, var.private1_subnet_id]
}

resource "aws_db_instance" "postgres" {
  identifier           = "postgres-db"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  db_name = var.postgresql_db
  username            = var.postgresql_user
  password            = var.postgresql_password
  skip_final_snapshot = true

  vpc_security_group_ids = [var.private_subnet_security_group_name_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}
