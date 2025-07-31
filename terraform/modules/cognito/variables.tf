// variables for Cognito

variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}

variable "user_pool_domain" {
  description = "Domain prefix for the Cognito User Pool Domain"
  type        = string
}

variable "client_name" {
  description = "Name of the Cognito User Pool Client"
  type        = string
}

variable "callback_urls" {
  description = "List of callback URLs for the client"
  type        = list(string)
  default     = ["http://localhost:3000/callback"]
}

variable "logout_urls" {
  description = "List of logout URLs for the client"
  type        = list(string)
  default     = ["http://localhost:3000/logout"]
}

variable "allowed_oauth_flows" {
  description = "List of allowed OAuth flows"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes"
  type        = list(string)
  default     = ["email", "openid", "profile"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

