variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "cv_bucket_name" {
  description = "Name of the CV upload S3 bucket"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 