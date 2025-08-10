# IAM role for Lambda functions
resource "aws_iam_role" "lambda_candidate_search_role" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for DynamoDB access
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.lambda_function_name}-dynamodb-policy"
  role = aws_iam_role.lambda_candidate_search_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = [
          "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}",
          "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}/index/*"
        ]
      }
    ]
  })
}

# CloudWatch Logs policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_candidate_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM role for generate presigned URL Lambda
resource "aws_iam_role" "lambda_generate_url_role" {
  name = "${var.generate_url_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for S3 presigned URL generation
resource "aws_iam_role_policy" "lambda_s3_presigned_policy" {
  name = "${var.generate_url_function_name}-s3-presigned-policy"
  role = aws_iam_role.lambda_generate_url_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.cv_bucket_name}/*"
        ]
      }
    ]
  })
}

# CloudWatch Logs policy for generate URL Lambda
resource "aws_iam_role_policy_attachment" "lambda_generate_url_logs" {
  role       = aws_iam_role.lambda_generate_url_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM role for Textract Lambda functions
resource "aws_iam_role" "lambda_textract_role" {
  name = "${var.textract_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for Textract service access
resource "aws_iam_role_policy" "lambda_textract_policy" {
  name = "${var.textract_function_name}-textract-policy"
  role = aws_iam_role.lambda_textract_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "textract:StartDocumentAnalysis",
          "textract:GetDocumentAnalysis"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.cv_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = [
          "arn:aws:dynamodb:*:*:table/${var.dynamodb_table_name}"
        ]
      }
    ]
  })
}

# IAM policy for SNS access (for Textract notifications)
resource "aws_iam_role_policy" "lambda_textract_sns_policy" {
  name = "${var.textract_function_name}-sns-policy"
  role = aws_iam_role.lambda_textract_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Logs policy for Textract Lambda
resource "aws_iam_role_policy_attachment" "lambda_textract_logs" {
  role       = aws_iam_role.lambda_textract_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# IAM role for Textract service to publish to SNS
resource "aws_iam_role" "textract_sns_role" {
  name = "textract-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "textract.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# IAM policy for Textract to publish to SNS
resource "aws_iam_role_policy" "textract_sns_policy" {
  name = "textract-sns-policy"
  role = aws_iam_role.textract_sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
} 