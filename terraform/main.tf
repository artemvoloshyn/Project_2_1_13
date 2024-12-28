module "vpc" {
  source                                    = "./modules/vpc"
  cidr                                      = var.cidr
  publicCIDR                                = var.publicCIDR
  public1CIDR                                = var.public1CIDR
  privateCIDR                               = var.privateCIDR
  private1CIDR                              = var.private1CIDR
  environment                               = var.environment
  availability_zone                         = var.availability_zone
  availability1_zone                        = var.availability1_zone
  security_group_name                       = var.security_group_name
  private_subnet_security_group_name        = var.private_subnet_security_group_name
  security_group_description                = var.security_group_description
  private_subnet_security_group_description = var.private_subnet_security_group_description
  allowed_ports                             = var.allowed_ports
  private_subnet_allowed_ports              = var.private_subnet_allowed_ports
}

module "elasticache" {
  source                                = "./modules/elasticache"
  private_subnet_id                     = module.vpc.aws_private_subnet_id
  private_subnet_security_group_name_id = module.vpc.aws_vpc_private_subnet_security_group_id
}

module "aws-rds" {
  source                                = "./modules/aws-rds"
  private_subnet_id                     = module.vpc.aws_private_subnet_id
  private1_subnet_id                    = module.vpc.aws_private1_subnet_id
  private_subnet_security_group_name_id = module.vpc.aws_vpc_private_subnet_security_group_id
  postgresql_db                         = var.postgresql_db_name
  postgresql_user                       = var.postgresql_user_name
  postgresql_password                   = var.postgresql_password_value
}


module "alb" {
  source                    = "./modules/alb"
  vpc_main_id = module.vpc.aws_vpc_main_id
  public_subnet_id = module.vpc.aws_public_subnet_id
  public1_subnet_id = module.vpc.aws_public1_subnet_id
  aws_vpc_security_group_id = module.vpc.aws_vpc_security_group_id
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name = var.ecs_cluster_name
  vpc_main_id = module.vpc.aws_vpc_main_id
  private1_subnet_id = module.vpc.aws_private1_subnet_id
  aws_vpc_private_subnet_security_group_id = module.vpc.aws_vpc_private_subnet_security_group_id
  aws_lb_target_group_frontend_arn = module.alb.frontend_alb_arn
  aws_redis_endpoint = module.elasticache.aws_redis_endpoint
  aws_redis_port = module.elasticache.aws_redis_port
  aws_postgresql_endpoint = module.aws-rds.aws_rds_postgres_endpoint
  aws_postgresql_name = var.postgresql_db_name
  aws_postgresql_password = var.postgresql_password_value
  aws_postgresql_port = module.aws-rds.aws_rds_postgres_port
  aws_region = var.aws_region
  aws_postgresql_user = var.postgresql_user_name
  ecs_task_execution_role = module.iam-role.ecs_task_execution_role
  cpu_frontend = var.cpu_frontend
  cpu_rds = var.cpu_rds
  cpu_redis = var.cpu_redis
  ram_frontend = var.ram_frontend
  ram_rds = var.ram_rds
  ram_redis = var.ram_redis




}

module "iam-role" {
  source                         = "./modules/iam-role"
  
}

