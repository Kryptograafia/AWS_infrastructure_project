# SNS Topic for Textract completion notifications
resource "aws_sns_topic" "textract_completion" {
  name = var.topic_name
  tags = var.tags
}

# SNS Topic Policy to allow Textract to publish
resource "aws_sns_topic_policy" "textract_completion_policy" {
  arn = aws_sns_topic.textract_completion.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "textract.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.textract_completion.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount": data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Get current AWS account ID
data "aws_caller_identity" "current" {} 