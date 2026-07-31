# compliant-s3

This module enforces SC-28, AU-3, AU-6, CM-6, and AC-3 on a single S3 bucket: server-side encryption (AES-256) protects data at rest (SC-28), a dedicated logging bucket with `aws_s3_bucket_logging` captures access records for audit review (AU-3/AU-6), versioning and default compliance tags applied via `default_tags` enforce consistent configuration management (CM-6), and an `aws_s3_bucket_public_access_block` on both the primary and log buckets denies every public access vector (AC-3).
