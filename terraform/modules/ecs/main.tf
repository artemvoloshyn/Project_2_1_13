resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

# Frontend Service
resource "aws_ecs_service" "frontend" {
  name            = "frontend"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.private1_subnet_id]
    security_groups = [var.aws_vpc_private_subnet_security_group_id]
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_frontend_arn
    container_name   = "frontend"
    container_port   = 80
  }
}

# Frontend Task Definition
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu_frontend
  memory                   = var.ram_frontend
  execution_role_arn = var.ecs_task_execution_role

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name = "BACKEND_RDS_URL"
          value = aws_ecs_service.backend_rds.id
        },
        {
          name = "BACKEND_REDIS_URL"
          value = aws_ecs_service.backend_redis.id
        },
      ]
    }
  ])
}

# Backend_rds Service
resource "aws_ecs_service" "backend_rds" {
  name            = "backend_rds"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_rds.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.backend_rds_service.arn
  }

  network_configuration {
    subnets         = [var.private1_subnet_id]
    security_groups = [var.aws_vpc_private_subnet_security_group_id]
  }
}

# Backend_rds Task Definition
resource "aws_ecs_task_definition" "backend_rds" {
  family                   = "backend_rds-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu_rds
  memory                   = var.ram_rds

  container_definitions = jsonencode([
    {
      name  = "backend_rds"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        {
          name = "DB_HOST"
          value = var.aws_postgresql_endpoint
        },
        {
          name = "DB_PORT"
          value = var.aws_postgresql_port
        },
        {
          name = "DB_NAME"
          value = var.aws_postgresql_name
        },
        {
          name = "DB_USER"
          value = var.aws_postgresql_user
        },
        {
          name = "DB_PASSWORD"
          value = var.aws_postgresql_password
        },
      ],
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.backend_rds_app_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "backend_rds"
       }
    }
  }
 ])
}



## CloudWatch backend_rds Log Group
resource "aws_cloudwatch_log_group" "backend_rds_app_logs" {
  name              = "/ecs/backend_rds_app-logs"
  retention_in_days = 30
}

# Backend_redis Service
resource "aws_ecs_service" "backend_redis" {
  name            = "backend_redis"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_redis.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  service_registries {
    registry_arn = aws_service_discovery_service.backend_redis_service.arn
  }

  network_configuration {
    subnets         = [var.private1_subnet_id]
    security_groups = [var.aws_vpc_private_subnet_security_group_id]
  }
}

# Backend_redis Task Definition
resource "aws_ecs_task_definition" "backend_redis" {
  family                   = "backend_redis-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu_redis
  memory                   = var.ram_redis

  container_definitions = jsonencode([
    {
      name  = "backend_redis"
      image = "nginx:latest"
      portMappings = [
        {
          containerPort = 8001
          hostPort      = 8001
        }
      ]
      environment = [
        {
          name = "REDIS_HOST"
          value = var.aws_redis_endpoint
        },
        {
          name = "REDIS_PORT"
          value = var.aws_redis_port
        }
      ],
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.backend_redis_app_logs.name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "backend_redis"
      }
    }
   } 
 ])
}


## CloudWatch backend_redis Log Group
resource "aws_cloudwatch_log_group" "backend_redis_app_logs" {
  name              = "/ecs/backend_redis_app-logs"
  retention_in_days = 30
}

## Service discovery 

resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "internal.example"
  vpc         = var.vpc_main_id
  description = "Internal service discovery namespace"
}

resource "aws_service_discovery_service" "backend_rds_service" {
  name = "backend_rds"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}

resource "aws_service_discovery_service" "backend_redis_service" {
  name = "backend_redis"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
}
