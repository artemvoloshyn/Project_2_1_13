resource "aws_elasticache_subnet_group" "cache_subnet_group" {
  name       = "cache-subnet-group"
  subnet_ids = [var.private_subnet_id]
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-cluster"
  engine              = "redis"
  node_type           = "cache.t3.micro"
  num_cache_nodes     = 1
  port                = 6379
  security_group_ids  = [var.private_subnet_security_group_name_id]
  subnet_group_name   = aws_elasticache_subnet_group.cache_subnet_group.name
}
