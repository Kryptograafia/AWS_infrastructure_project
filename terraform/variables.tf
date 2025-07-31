variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID to restrict deployment"
  type        = string
}

variable "cv_upload_bucket_name" {
  description = "The globally unique bucket name"
  type        = string
  #default     = "cv-upload-bucket-6728b"
}

variable "website_bucket_name" {
  description = "The globally unique bucket name"
  type        = string
  #default     = "website-bucket-6728b"
}

