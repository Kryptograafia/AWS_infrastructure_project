output "bucket_name" {
  description = "The name of the CV upload bucket."
  value       = aws_s3_bucket.cv_upload_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the CV upload bucket."
  value       = aws_s3_bucket.cv_upload_bucket.arn
}
