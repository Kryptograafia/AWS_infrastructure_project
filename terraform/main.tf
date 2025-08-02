module "cv_bucket" {
  source = "./modules/s3/cv_bucket"
  cv_upload_bucket_name = var.cv_upload_bucket_name
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
  tags = {
    Environment = "development"
    Project     = "hr-system"
  }
}


