resource "aws_lambda_function" "process_housing" {
  function_name = "process_housing_${var.environment}"
  filename      = "../lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = var.lambda_timeout

  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [module.vpc.default_security_group_id]
  }

  environment {
    variables = {
      DB_HOST     = aws_db_instance.default.address
      DB_NAME     = aws_db_instance.default.db_name
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_PORT     = aws_db_instance.default.port
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_exec_attach]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_housing.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.housing.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.housing.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_housing.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
