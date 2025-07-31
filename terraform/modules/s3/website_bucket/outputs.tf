output "bucket_name" {
  description = "The name of the website bucket."
  value       = aws_s3_bucket.website_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the website bucket."
  value       = aws_s3_bucket.website_bucket.arn
}

output "website_endpoint" {
  description = "The website endpoint URL."
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
} 