output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.housing.id
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.process_housing.function_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.default.address
}
