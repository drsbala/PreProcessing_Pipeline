
# Terraform for California Housing Pipeline

## Setup

1. **Install Dependencies**  
   Install Terraform, Python, and required Python packages:
   ```bash
   # Install Terraform
   brew install terraform # or use your package manager

   # Install Python dependencies
   pip install pandas psycopg2-binary pytest
   ```

2. **Create `terraform.tfvars`**  
   Add the following content to `terraform.tfvars`:
   ```hcl
   db_password = "YOUR_DB_PASSWORD"
   ```

3. **Package Lambda Function**  
   Build and package your Lambda function:
   ```bash
   make package
   ```

4. **Deploy Infrastructure**  
   Use the Makefile to initialize, plan, and apply your Terraform configurations:
   ```bash
   make
   ```

5. **Test Lambda Function**  
   To test your Lambda function locally, you can simulate the AWS Lambda environment using tools like [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) or directly deploy it to AWS to test using S3 uploads.

## Structure

- `provider.tf`: AWS provider configuration.
- `variables.tf`: Input variables.
- `vpc.tf`: VPC module.
- `s3.tf`: S3 bucket configuration.
- `iam.tf`: IAM roles and policies.
- `rds.tf`: RDS PostgreSQL instance setup.
- `lambda.tf`: Lambda function and S3 trigger.
- `outputs.tf`: Output variables.
- `Makefile`: Makefile for packaging, deploying, and testing.
- `tests/`: Directory containing unit tests.

## Security

- **VPC**: Private subnets for Lambda functions and RDS instances, with a NAT gateway for internet access.
- **S3**: Server-side encryption (AES256) enabled, public access blocked.
- **RDS**: Database storage is encrypted and accessible only from within the VPC.
- **IAM**: Roles and policies follow least privilege principles.

## CI/CD with GitHub Actions

You can add a GitHub Actions pipeline to automate the deployment process.

```yaml
name: Deploy AWS Housing Pipeline

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 1.0.0

    - name: Install Python dependencies
      run: |
        python -m pip install --upgrade pip
        pip install pandas psycopg2-binary

    - name: Install Terraform dependencies
      run: terraform init

    - name: Run Terraform Plan
      run: terraform plan -var-file=terraform.tfvars

    - name: Run Terraform Apply
      run: terraform apply -var-file=terraform.tfvars -auto-approve

    - name: Deploy Lambda Package
      run: |
        zip -r lambda_function.zip lambda_function.py pandas psycopg2-binary
        aws s3 cp lambda_function.zip s3://YOUR_BUCKET_NAME/
```

## Testing

- **Unit Tests**: You can run unit tests with `pytest`:
   ```bash
   make test
   ```

- **Manual Testing**: Upload a CSV file to the S3 bucket to trigger the Lambda function.

## Troubleshooting

If you encounter any issues:
- Check the Lambda logs in CloudWatch.
- Verify IAM roles and policies.
- Make sure the S3 event is properly configured.
