
resource "aws_api_gateway_rest_api" "api" {
 name = "automate-api-gateway"
 description = "Automate next API Gateway"
}


resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "{$aws_lambda_function.terraform_lambda_func.invoke_arn}"
   
}










# resource "aws_api_gateway_authorizer" "demo" {
#   name                   = "demo"
#   rest_api_id            = aws_api_gateway_rest_api.demo.id
#   authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
#   authorizer_credentials = aws_iam_role.invocation_role.arn
# }

# resource "aws_api_gateway_rest_api" "demo" {
#   name = "auth-demo"
# }

# resource "aws_iam_role" "invocation_role" {
#   name = "api_gateway_auth_invocation"
#   path = "/"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "apigateway.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "invocation_policy" {
#   name = "default"
#   role = aws_iam_role.invocation_role.id

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "lambda:InvokeFunction",
#       "Effect": "Allow",
#       "Resource": "${aws_lambda_function.authorizer.arn}"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role" "lambda" {
#   name = "demo-lambda"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_lambda_function" "authorizer" {
#   filename      = "lambda-function.zip"
#   function_name = "api_gateway_authorizer"
#   role          = aws_iam_role.lambda.arn
#   handler       = "exports.example"

#   source_code_hash = filebase64sha256("lambda-function.zip")
# }
