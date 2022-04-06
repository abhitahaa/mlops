# resource "aws_cognito_user_pool" "pool" {
#   name = "test2456"
#   auto_verified_attributes = ["email"]

#   schema {
#     name                     = "terraform"
#     attribute_data_type      = "Boolean"
#     mutable                  = false
#     required                 = false
#     developer_only_attribute = false
#   }

#   schema {
#     name                     = "foo"
#     attribute_data_type      = "String"
#     mutable                  = false
#     required                 = false
#     developer_only_attribute = false
#     string_attribute_constraints {}
#   }
#   schema {
#     name                     = "password"
#     attribute_data_type      = "String"
#     mutable                  = false
#     required                 = false
#     developer_only_attribute = false
#   }
#   schema {
#     name                     = "message_action"
#     attribute_data_type      = "String"
#     mutable                  = false
#     required                 = false
#     developer_only_attribute = false
#    }
# }

# resource "aws_cognito_user" "example" {
#   user_pool_id = aws_cognito_user_pool.pool.id
#   username     = "abhitahaa3433"

#   attributes = {
#     terraform      = true
#     foo            = "bar"
#     email          = "abhitahaa@gmail.com"
#     email_verified = true
#     password = "Test@123"
#     message_action = "SUPPRESS"
#   }
# #   lifecycle {
# #     ignore_changes = [
# #       password_length,
# #       password_reset_required
# #           ]
# #   }
# }

# # resource "null_resource" "example" {
# #   provisioner "local-exec" {
# #   command = "aws cognito-idp admin-set-user-password \ --user-pool-id <aws_cognito_user_pool.pool.id> \  --username <abhitahaa233> \  --password <"Test@123" \  --permanent"


# resource "aws_cognito_user_pool_client" "client" {
#   name = "clientss"
#   user_pool_id = "${aws_cognito_user_pool.pool.id}" # the cognito pool id created in step 1
#   generate_secret                      = true
#   explicit_auth_flows                  = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
#   allowed_oauth_flows_user_pool_client = true
#   allowed_oauth_flows                  = ["code","implicit"]
#   supported_identity_providers         = ["COGNITO"]
#   allowed_oauth_scopes                 = ["openid"]

#   callback_urls = ["https://example.com"]
# }


# resource "aws_cognito_user_pool_domain" "main" {
#   domain       = "abhitahaatest"
#   user_pool_id = aws_cognito_user_pool.pool.id
# }


# resource "aws_cognito_resource_server" "resource" {
#   identifier = "https://example.com"
#   name       = "example"

#   scope {
#     scope_name        = "json.write"
#     scope_description = "write json data"
#    }
#   scope {
#     scope_name        = "json.read"
#     scope_description = "read json data"
#    }
#   user_pool_id = aws_cognito_user_pool.pool.id
# }

