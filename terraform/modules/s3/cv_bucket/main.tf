resource "aws_s3_bucket" "cv_upload_bucket" {
    bucket = var.cv_upload_bucket_name
    tags = {
      Project = "ResumeParser"
    }
}

# Public access block for security
resource "aws_s3_bucket_public_access_block" "cv_upload_bucket" {
  bucket = aws_s3_bucket.cv_upload_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#Set SSE-S3 as default encryption method
resource "aws_s3_bucket_server_side_encryption_configuration" "cv_upload_bucket" {
  bucket = aws_s3_bucket.cv_upload_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cv_upload_bucket_lifecycle" {
  bucket = aws_s3_bucket.cv_upload_bucket.id

  rule {
    id     = "expire-old-cvs"
    status = "Enabled"

    filter {
      prefix = ""  # Applies to all CVs in all company folders
    }

    expiration {
      days = 360 # Deletes CVs after 360 days
    }
  }
}