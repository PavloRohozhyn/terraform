output "s3_bucket_id" {
  value = aws_s3_bucket.terraform_state.id
  description = "ID of S3 bucket"
}
output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "ARN of S3 bucket"
}
output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "name of DynamoDB"
}
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.terraform_locks.arn
  description = "ARN of DynamoDB"
}