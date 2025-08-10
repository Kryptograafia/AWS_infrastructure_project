output "textract_processor_function_arn" {
  description = "ARN of the Textract processor Lambda function"
  value       = aws_lambda_function.textract_processor.arn
}

output "textract_processor_function_name" {
  description = "Name of the Textract processor Lambda function"
  value       = aws_lambda_function.textract_processor.function_name
}

output "cv_parser_function_arn" {
  description = "ARN of the CV parser Lambda function"
  value       = aws_lambda_function.cv_parser.arn
}

output "cv_parser_function_name" {
  description = "Name of the CV parser Lambda function"
  value       = aws_lambda_function.cv_parser.function_name
}