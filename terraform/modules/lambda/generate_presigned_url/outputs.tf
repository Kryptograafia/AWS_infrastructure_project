output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.generate_upload_url.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.generate_upload_url.function_name
}

output "invoke_arn" {
  description = "Invocation ARN of the Lambda function"
  value       = aws_lambda_function.generate_upload_url.invoke_arn
} 