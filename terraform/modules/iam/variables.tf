variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "generate_url_function_name" {
  description = "Name of the generate URL Lambda function"
  type        = string
}

variable "cv_bucket_name" {
  description = "Name of the CV upload S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 