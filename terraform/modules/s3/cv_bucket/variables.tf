variable "cv_upload_bucket_name" {
  description = "The globally unique bucket name for CV uploads."
  type        = string
}

variable "textract_lambda_arn" {
  description = "ARN of the Textract Lambda function to trigger on file uploads"
  type        = string
  
  validation {
    condition     = length(var.textract_lambda_arn) > 0
    error_message = "textract_lambda_arn cannot be empty"
  }
}

variable "textract_lambda_function_name" {
  description = "Name of the Textract Lambda function"
  type        = string
  
  validation {
    condition     = length(var.textract_lambda_function_name) > 0
    error_message = "textract_lambda_function_name cannot be empty"
  }
}
