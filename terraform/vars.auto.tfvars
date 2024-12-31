aws_region                                = "us-east-1"
availability_zone                         = "us-east-1a"
availability1_zone                        = "us-east-1b"
environment                               = "public-alb"
instance_type                             = "t2.micro"
cidr                                      = "10.0.0.0/16"
publicCIDR                                = "10.0.1.0/24"
public1CIDR                                = "10.0.4.0/24"
privateCIDR                               = "10.0.2.0/24"
private1CIDR                              = "10.0.3.0/24"
security_group_name                       = "public-sg"
private_subnet_security_group_name        = "private-sg"
security_group_description                = "public-sg"
private_subnet_security_group_description = "private-sg"
allowed_ports                             = ["80", "22", "443", "8080", "8000", "8001"]
private_subnet_allowed_ports              = ["5432", "6379", "80", "443", "8000", "8001"]
whitelist_locations                       = ["US", "CA", "GB", "DE", "PL"]
aws_s3_bucket_name                        = "t-e-s-t-9-8-765432-1"
index_html_source                         = "../frontend/templates/index.html"
config_json_source                        = "../frontend/config.json"
aws_user_account_id                       = "087143128777"
postgresql_db_name                        = "my_db"
postgresql_user_name                      = "my_user"
postgresql_password_value                 = "my_password"
cpu_frontend = "256"
cpu_rds = "256"
cpu_redis = "256"
ram_frontend = "512"
ram_rds = "512"
ram_redis = "512"
ecs_cluster_name = "App"