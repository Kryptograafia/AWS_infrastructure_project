variable "textract_processor_function_name" {
  description = "Name of the Textract processor Lambda function"
  type        = string
}

variable "cv_parser_function_name" {
  description = "Name of the CV parser Lambda function"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table to store processed CV data"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for the Textract Lambda functions"
  type        = string
}

variable "cv_bucket_name" {
  description = "Name of the S3 bucket where CVs are uploaded"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for Textract completion notifications"
  type        = string
}

variable "textract_sns_role_arn" {
  description = "ARN of the IAM role for Textract to publish to SNS"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}