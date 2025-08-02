output "lambda_candidate_search_role_arn" {
  description = "ARN of the Lambda candidate search IAM role"
  value       = aws_iam_role.lambda_candidate_search_role.arn
} 