# Lambda function for generating presigned URLs
resource "aws_lambda_function" "generate_upload_url" {
  filename         = "${path.module}/generate_upload_url.zip"
  function_name    = var.function_name
  role            = var.lambda_role_arn
  handler         = "generate_upload_url.handler"
  runtime         = "python3.9"
  timeout         = 30

  environment {
    variables = {
      CV_BUCKET_NAME = var.cv_bucket_name
    }
  }

  tags = var.tags
} 