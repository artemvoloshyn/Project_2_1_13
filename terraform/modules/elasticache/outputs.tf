output "aws_redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address

}

output "aws_redis_port" {
  value = aws_elasticache_cluster.redis.port

}