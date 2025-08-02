# Lambda function for searching candidates
resource "aws_lambda_function" "search_candidates" {
  filename         = "search_candidates.zip"
  function_name    = var.function_name
  role            = var.lambda_role_arn
  handler         = "lambda_function.handler" #filename.functionname
  runtime         = "python3.9"
  timeout         = 30

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  tags = var.tags
} 