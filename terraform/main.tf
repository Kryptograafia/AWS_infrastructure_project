# SNS module for Textract completion notifications
module "sns" {
  source = "./modules/sns"
  topic_name = "textract-completion-notifications"
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

module "website_bucket" {
  source = "./modules/s3/website_bucket"
  website_bucket_name = var.website_bucket_name
}

module "cognito" {
  source = "./modules/cognito"
  user_pool_name = "hr-system-user-pool"
  user_pool_domain = "hr-system-auth"
  client_name = "hr-system-client"
  
  callback_urls = [
    "http://localhost:3000/callback",
    "https://localhost:3000/callback"
  ]
  
  logout_urls = [
    "http://localhost:3000/logout",
    "https://localhost:3000/logout"
  ]
  
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"
  table_name = "candidates"
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

# IAM module for Lambda roles and policies
module "iam" {
  source = "./modules/iam"
  lambda_function_name = "hr-search-candidates"
  dynamodb_table_name = module.dynamodb.table_name
  generate_url_function_name = "hr-generate-upload-url"
  textract_function_name = "hr-textract-processor"
  cv_bucket_name = var.cv_upload_bucket_name  # Use variable instead of module reference
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

# Lambda function for CV text extraction using Textract (MOVE THIS BEFORE cv_bucket)
module "lambda_textract" {
  source = "./modules/lambda/textract"
  textract_processor_function_name = "hr-textract-processor"
  cv_parser_function_name = "hr-cv-parser"
  dynamodb_table_name = module.dynamodb.table_name
  lambda_role_arn = module.iam.lambda_textract_role_arn
  cv_bucket_name = var.cv_upload_bucket_name  # Use variable instead of module reference
  sns_topic_arn = module.sns.topic_arn
  textract_sns_role_arn = module.iam.textract_sns_role_arn
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

# NOW define cv_bucket after lambda_textract is defined
module "cv_bucket" {
  source = "./modules/s3/cv_bucket"
  cv_upload_bucket_name = var.cv_upload_bucket_name
  textract_lambda_arn = module.lambda_textract.textract_processor_function_arn
  textract_lambda_function_name = module.lambda_textract.textract_processor_function_name
}

# Lambda function for generating presigned URLs
module "lambda_generate_url" {
  source = "./modules/lambda/generate_presigned_url"
  function_name = "hr-generate-upload-url"
  cv_bucket_name = module.cv_bucket.bucket_name
  lambda_role_arn = module.iam.lambda_generate_url_role_arn
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

# Lambda function for searching candidates
module "lambda_hr_search" {
  source = "./modules/lambda/hr_search"
  function_name = "hr-search-candidates"
  dynamodb_table_name = module.dynamodb.table_name
  lambda_role_arn = module.iam.lambda_candidate_search_role_arn
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}

module "api_gateway" {
  source = "./modules/api_gateway"
  api_name = "hr-system-api"
  lambda_search_function_arn = module.lambda_hr_search.function_arn
  lambda_search_invoke_arn = module.lambda_hr_search.invoke_arn
  lambda_generate_url_function_arn = module.lambda_generate_url.function_arn
  lambda_generate_url_invoke_arn = module.lambda_generate_url.invoke_arn
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}


