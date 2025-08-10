# First Lambda - Textract Processor
resource "aws_lambda_function" "textract_processor" {
  filename         = "${path.module}/start_textract.zip"
  function_name    = var.textract_processor_function_name
  role            = var.lambda_role_arn
  handler         = "start_textract.handler"
  runtime         = "python3.9"
  timeout         = 30
  memory_size     = 128

  environment {
    variables = {
      TEXTRACT_SNS_TOPIC_ARN = var.sns_topic_arn
      TEXTRACT_SNS_ROLE_ARN  = var.textract_sns_role_arn
    }
  }

  tags = var.tags
}

# Second Lambda - CV Parser
resource "aws_lambda_function" "cv_parser" {
  filename         = "${path.module}/process_cv.zip"
  function_name    = var.cv_parser_function_name
  role            = var.lambda_role_arn
  handler         = "process_cv.handler"
  runtime         = "python3.9"
  timeout         = 300  # 5 minutes for processing large documents
  memory_size     = 512   # More memory for text processing

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }

  tags = var.tags
}

# Allow SNS to invoke the CV parser Lambda
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cv_parser.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

# SNS subscription to trigger CV parser Lambda when Textract completes
resource "aws_sns_topic_subscription" "cv_parser_lambda_target" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.cv_parser.arn
}

# CloudWatch Log Group for Textract processor
resource "aws_cloudwatch_log_group" "textract_processor_logs" {
  name              = "/aws/lambda/${var.textract_processor_function_name}"
  retention_in_days = 14
  tags              = var.tags
}

# CloudWatch Log Group for CV parser
resource "aws_cloudwatch_log_group" "cv_parser_logs" {
  name              = "/aws/lambda/${var.cv_parser_function_name}"
  retention_in_days = 14
  tags              = var.tags
}