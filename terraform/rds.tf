resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group-${var.environment}"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = var.environment
  }
}

resource "aws_db_instance" "default" {
  identifier             = "housing-db-${var.environment}"
  engine                 = "postgres"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  name                   = "housingdb"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  storage_encrypted      = true

  tags = {
    Environment = var.environment
  }
}
