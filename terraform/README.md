# Terraform for California Housing Pipeline

## Setup

1. **Build and package your Lambda code**  
   Place your `lambda_function.py` and dependencies in a folder, then run:  
   ```bash
   zip lambda_function.zip lambda_function.py pandas psycopg2-binary
   ```  
   Move `lambda_function.zip` into this directory.

2. **Create `terraform.tfvars`**  
   ```hcl
   db_password = "YOUR_DB_PASSWORD"
   ```

3. **Deploy**  
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Structure

- `provider.tf`: AWS provider configuration.
- `variables.tf`: input variables.
- `vpc.tf`: VPC module.
- `s3.tf`: S3 bucket.
- `iam.tf`: IAM roles and policies.
- `rds.tf`: RDS PostgreSQL instance.
- `lambda.tf`: Lambda function and S3 trigger.
- `outputs.tf`: Outputs.

## Security

- Private VPC subnets with NAT gateway.
- S3 server-side encryption and public access blocked.
- RDS storage encryption.
- IAM roles follow least privilege.
