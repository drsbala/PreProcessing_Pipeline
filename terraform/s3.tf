resource "aws_s3_bucket" "housing" {
  bucket = var.s3_bucket_name

  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_public_access_block" "housing" {
  bucket = aws_s3_bucket.housing.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}
