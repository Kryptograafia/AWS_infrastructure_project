# API Gateway REST API
resource "aws_api_gateway_rest_api" "main" {
  name = var.api_name
  description = "HR System API Gateway"
}

# ========================================
# ROOT ENDPOINT (/)
# ========================================

# Get the default root resource
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  path        = "/"
}

# GET method for root resource
resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = data.aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"
}

# Mock integration for GET method
resource "aws_api_gateway_integration" "root_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = data.aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.root_get.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method response for GET
resource "aws_api_gateway_method_response" "root_get_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = data.aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.root_get.http_method
  status_code = "200"
}

# Integration response for GET
resource "aws_api_gateway_integration_response" "root_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = data.aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.root_get.http_method
  status_code = aws_api_gateway_method_response.root_get_response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"HR System API is working!\"}"
  }
}

# ========================================
# GENERATE UPLOAD URL ENDPOINT (/generate-upload-url)
# ========================================

# Generate upload URL resource
resource "aws_api_gateway_resource" "generate_upload_url" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "generate-upload-url"
}

# POST method for generate-upload-url resource
resource "aws_api_gateway_method" "generate_upload_url_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.generate_upload_url.id
  http_method   = "POST"
  authorization = "NONE"
}

# Lambda integration for generate-upload-url POST method
resource "aws_api_gateway_integration" "generate_upload_url_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.generate_upload_url.id
  http_method = aws_api_gateway_method.generate_upload_url_post.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_generate_url_invoke_arn
}

# ========================================
# UPLOAD CV ENDPOINT (/upload-cv)
# ========================================

# Upload CV resource
resource "aws_api_gateway_resource" "upload_cv" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "upload-cv"
}

# POST method for upload-cv resource
resource "aws_api_gateway_method" "upload_cv_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.upload_cv.id
  http_method   = "POST"
  authorization = "NONE"
}

# Mock integration for upload-cv POST method
resource "aws_api_gateway_integration" "upload_cv_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.upload_cv.id
  http_method = aws_api_gateway_method.upload_cv_post.http_method

  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method response for upload-cv POST
resource "aws_api_gateway_method_response" "upload_cv_post_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.upload_cv.id
  http_method = aws_api_gateway_method.upload_cv_post.http_method
  status_code = "201"
}

# Integration response for upload-cv POST
resource "aws_api_gateway_integration_response" "upload_cv_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.upload_cv.id
  http_method = aws_api_gateway_method.upload_cv_post.http_method
  status_code = aws_api_gateway_method_response.upload_cv_post_response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"CV upload endpoint ready!\"}"
  }
}

# ========================================
# SEARCH CANDIDATES ENDPOINT (/search-candidates)
# ========================================

# Search candidates resource
resource "aws_api_gateway_resource" "search_candidates" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "search-candidates"
}

# GET method for search-candidates resource
resource "aws_api_gateway_method" "search_candidates_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.search_candidates.id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda integration for search-candidates GET method
resource "aws_api_gateway_integration" "search_candidates_get_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.search_candidates.id
  http_method = aws_api_gateway_method.search_candidates_get.http_method

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_search_invoke_arn
}

# Method response for search-candidates GET
resource "aws_api_gateway_method_response" "search_candidates_get_response" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.search_candidates.id
  http_method = aws_api_gateway_method.search_candidates_get.http_method
  status_code = "200"
}

# ========================================
# LAMBDA PERMISSIONS
# ========================================

# Allow API Gateway to invoke search Lambda function
resource "aws_lambda_permission" "search_candidates_api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_search_function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/search-candidates"
}

# Allow API Gateway to invoke generate URL Lambda function
resource "aws_lambda_permission" "generate_url_api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_generate_url_function_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/generate-upload-url"
}

# ========================================
# DEPLOYMENT & STAGE
# ========================================

# Deployment
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_integration.root_get_integration,
    aws_api_gateway_integration_response.root_get_integration_response,
    aws_api_gateway_integration.generate_upload_url_post_integration,
    aws_api_gateway_integration.upload_cv_post_integration,
    aws_api_gateway_integration_response.upload_cv_post_integration_response,
    aws_api_gateway_integration.search_candidates_get_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
  
  # Force new deployment when there are changes in endpoints
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_integration.root_get_integration,
      aws_api_gateway_integration.generate_upload_url_post_integration,
      aws_api_gateway_integration.upload_cv_post_integration,
      aws_api_gateway_integration.search_candidates_get_integration
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Stage
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "dev"
} 