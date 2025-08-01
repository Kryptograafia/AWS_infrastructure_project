# DynamoDB table for candidates
resource "aws_dynamodb_table" "candidates" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  # TTL - automatically delete records after 360 days
  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

  tags = var.tags
} 