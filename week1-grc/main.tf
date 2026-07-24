terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# The bucket itself
resource "aws_s3_bucket" "compliant_bucket" {
  bucket = "my-compliant-bucket-week1-12345"

  tags = {
    Environment = "GRC-Training"
    Week        = "Week1"
    ManagedBy   = "Terraform"
  }
}

# Control 1: Block all public access
resource "aws_s3_bucket_public_access_block" "compliant_bucket" {
  bucket                  = aws_s3_bucket.compliant_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Control 2: Encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "compliant_bucket" {
  bucket = aws_s3_bucket.compliant_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Control 3: Versioning
resource "aws_s3_bucket_versioning" "compliant_bucket" {
  bucket = aws_s3_bucket.compliant_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Control 4: Access logging (logs go to a separate bucket)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-compliant-bucket-week1-logs-123456"

  tags = {
    Environment = "GRC-Training"
    Purpose     = "AccessLogs"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_logging" "compliant_bucket" {
  bucket        = aws_s3_bucket.compliant_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "access-logs/"
}

output "bucket_proof" {
  value = {
    bucket_name        = aws_s3_bucket.compliant_bucket.id
    bucket_arn         = aws_s3_bucket.compliant_bucket.arn
    region             = aws_s3_bucket.compliant_bucket.region
    versioning_enabled = aws_s3_bucket_versioning.compliant_bucket.versioning_configuration[0].status
    encryption = tolist(aws_s3_bucket_server_side_encryption_configuration.compliant_bucket.rule)[0].apply_server_side_encryption_by_default[0].sse_algorithm
    public_access_blocked = aws_s3_bucket_public_access_block.compliant_bucket.block_public_acls
    logging_target     = aws_s3_bucket_logging.compliant_bucket.target_bucket
    tags               = aws_s3_bucket.compliant_bucket.tags_all
  }
}

