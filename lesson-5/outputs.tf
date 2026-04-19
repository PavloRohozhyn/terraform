# S3 backend output
output "s3_bucket_name" {
  description = "Name of S3 bucket"
  value       = module.s3_backend.s3_bucket_id
}
output "dynamodb_table_name" {
  description = "Name of DynamoDB"
  value       = module.s3_backend.dynamodb_table_name
}

# VPC output
output "vpc_id" {
  description = "ID of VPC"
  value       = module.vpc.vpc_id
}
output "public_subnet_ids" {
  description = "ID of public subnets"
  value       = module.vpc.public_subnet_ids
}
output "private_subnet_ids" {
  description = "ID of private subnets"
  value       = module.vpc.private_subnet_ids
}

# ECR module
output "ecr_repository_url" {
  description = "URL of ECR repo"
  value       = module.ecr.repository_url
}