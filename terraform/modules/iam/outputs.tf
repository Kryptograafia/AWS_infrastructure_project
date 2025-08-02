output "lambda_candidate_search_role_arn" {
  description = "ARN of the Lambda candidate search role"
  value       = aws_iam_role.lambda_candidate_search_role.arn
}

output "lambda_generate_url_role_arn" {
  description = "ARN of the Lambda generate URL role"
  value       = aws_iam_role.lambda_generate_url_role.arn
} 