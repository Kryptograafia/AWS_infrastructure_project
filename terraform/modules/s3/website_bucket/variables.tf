variable "website_bucket_name" {
  description = "The globally unique bucket name for the static website."
  type        = string
}

variable "index_document" {
  description = "The index document for the static website."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the static website."
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
} 