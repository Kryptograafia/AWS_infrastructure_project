# S3 Bucket Outputs
output "cv_upload_bucket_name" {
  description = "Name of the CV upload bucket"
  value       = module.cv_bucket.bucket_name
}

output "cv_upload_bucket_arn" {
  description = "ARN of the CV upload bucket"
  value       = module.cv_bucket.bucket_arn
}

output "website_bucket_name" {
  description = "Name of the website bucket"
  value       = module.website_bucket.bucket_name
}

output "website_bucket_arn" {
  description = "ARN of the website bucket"
  value       = module.website_bucket.bucket_arn
}

# Cognito Outputs
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_domain" {
  description = "Domain of the Cognito User Pool"
  value       = module.cognito.user_pool_domain
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = module.cognito.user_pool_client_id
}

output "cognito_user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = module.cognito.user_pool_endpoint
}

# API Gateway Outputs
output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = module.api_gateway.api_gateway_url
}

# Cognito Authentication URLs
output "cognito_signup_url" {
  description = "URL for user sign up"
  value       = "https://${module.cognito.user_pool_domain}.auth.${var.aws_region}.amazoncognito.com/signup?client_id=${module.cognito.user_pool_client_id}&response_type=code&scope=email+openid+profile&redirect_uri=http://localhost:3000/callback"
}

output "cognito_login_url" {
  description = "URL for user login"
  value       = "https://${module.cognito.user_pool_domain}.auth.${var.aws_region}.amazoncognito.com/login?client_id=${module.cognito.user_pool_client_id}&response_type=code&scope=email+openid+profile&redirect_uri=http://localhost:3000/callback"
}

output "cognito_logout_url" {
  description = "URL for user logout"
  value       = "https://${module.cognito.user_pool_domain}.auth.${var.aws_region}.amazoncognito.com/logout?client_id=${module.cognito.user_pool_client_id}&logout_uri=http://localhost:3000/logout"
} 