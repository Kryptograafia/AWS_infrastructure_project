variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "lambda_search_function_arn" {
  description = "Function ARN of the Lambda function for searching candidates (for permissions)"
  type        = string
}

variable "lambda_search_invoke_arn" {
  description = "Invoke ARN of the Lambda function for searching candidates (for integrations)"
  type        = string
}

variable "lambda_generate_url_function_arn" {
  description = "Function ARN of the Lambda function for generating presigned URLs (for permissions)"
  type        = string
}

variable "lambda_generate_url_invoke_arn" {
  description = "Invoke ARN of the Lambda function for generating presigned URLs (for integrations)"
  type        = string
} 