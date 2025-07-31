# main.tf for Cognito

# Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name = var.user_pool_name

  # Password policy
  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Username attributes
  username_attributes = ["email"]

  # Verification message template
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Your verification code"
    email_message = "Your verification code is {####}"
  }

  # MFA configuration
  mfa_configuration = "OPTIONAL"

  # Configure MFA methods
  software_token_mfa_configuration {
    enabled = true
  }

  # User pool add-ons
  user_pool_add_ons {
    advanced_security_mode = "OFF"  # Can be "OFF", "AUDIT", or "ENFORCED"
  }

  # Device configuration
  device_configuration {
    challenge_required_on_new_device = true    # Require verification on new devices
    device_only_remembered_on_user_prompt = true  # Let users choose what to remember
  }


  # Account recovery settings
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "main" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.main.id

  # Generate client secret
  generate_secret = false

  # Enable OAuth flows for user pool client
  allowed_oauth_flows_user_pool_client = true

  # Enable OAuth flows
  allowed_oauth_flows = var.allowed_oauth_flows

  # Callback URLs (where users are redirected after sign-in)
  callback_urls = var.callback_urls

  # Logout URLs (where users are redirected after sign-out)
  logout_urls = var.logout_urls

  # Allowed OAuth scopes
  allowed_oauth_scopes = var.allowed_oauth_scopes

  # Supported identity providers
  supported_identity_providers = ["COGNITO"]

  # Token validity
  access_token_validity  = 1  # 1 hour
  id_token_validity      = 1  # 1 hour
  refresh_token_validity = 1 # 1 days

  # Prevent user existence errors
  prevent_user_existence_errors = "ENABLED"
}

# Cognito User Pool Domain
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.main.id
}


