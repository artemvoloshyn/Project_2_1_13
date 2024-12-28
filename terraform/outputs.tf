# output "EC2_public_IP" {
#   value = module.ec2.EC2_public_IP
# }

# output "CDN_URL" {
#   value = module.cloudfront.aws_cloudfront_domain_name
# }

# output "CDN_ID" {
#   value = module.cloudfront.aws_cloudfront_distribution_id
# }

output "AWS-RDS" {
  value = module.aws-rds.aws_rds_postgres_endpoint

}

output "ELASTICACHE" {
  value = module.elasticache.aws_redis_endpoint

}