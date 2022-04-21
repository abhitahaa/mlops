
resource "aws_api_gateway_rest_api" "api" {
  name        = "new_automate-api-gateway"
  description = "Automate next API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "Test_ProbPred_AN_test"
}

/* resource "aws_api_gateway_method" "method" {
   rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
   resource_id   = "${aws_api_gateway_resource.proxy.id}"
   http_method   = "ANY"
   authorization = "NONE"
  # request_parameters = {
#     "method.request.path.proxy" = true
   } */
#}
resource "aws_api_gateway_method" "postmethod" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  #   request_parameters = {
  #     "method.request.path.proxy" = true
  #   }
}

/* resource "aws_api_gateway_method" "gettmethod" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "GET"
  authorization = "NONE"
  #   request_parameters = {
  #     "method.request.path.proxy" = true
  #   }
} */

/* resource "aws_api_gateway_integration" "lambda_test" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = "ANY"
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn

} */

resource "aws_api_gateway_integration" "lambda_test" {
  depends_on = [ #aws_lambda_permission.lambda_permission,
  aws_lambda_function.terraform_lambda_func]
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.postmethod.http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn
  #credentials             = "arn:aws:iam::384941664403:role/apigatewayawsproxyexecrole"
  credentials = aws_iam_role.apigateway_role.arn
}

/* resource "aws_api_gateway_integration" "lambda_gettest" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.gettmethod.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda_func.invoke_arn

}  */

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_test
    #aws_api_gateway_integration.lambda_gettest
  ]

  #  triggers = {
  # NOTE: The configuration below will satisfy ordering considerations,
  #       but not pick up all future REST API changes. More advanced patterns
  #       are possible, such as using the filesha1() function against the
  #       Terraform configuration file(s) or removing the .id references to
  #       calculate a hash against whole resources. Be aware that using whole
  #       resources will show a difference after the initial implementation.
  #       It will stabilize to only change when resources change afterwards.
  #   redeployment = sha1(jsonencode([
  #    aws_api_gateway_resource.proxy.id,
  #    aws_api_gateway_method.postmethod.id,
  #     aws_api_gateway_integration.lambda_test.id,
  #  ]))
  # }

  # lifecycle {
  #  create_before_destroy = true
  #}


  rest_api_id = aws_api_gateway_rest_api.api.id
  #stage_name  = "abc"

}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "abc"
}

resource "aws_api_gateway_stage" "testexample" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}





/* resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "abc"
} */




/* resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "apigateway.amazonaws.com"

  #source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*
  #source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/ #${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.proxy.path}"
#} */



data "aws_caller_identity" "current" {}

resource "aws_lambda_permission" "lambda_permission" {
  depends_on = [aws_api_gateway_method.postmethod]
  #statement_id = "AllowAPIInvoke"
  action = "lambda:InvokeFunction"

  #your lambda function ARN
  function_name = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.terraform_lambda_func.function_name}"
  #function_name = "helloworld_Lambda_Function"
  principal = "apigateway.amazonaws.com"
  #source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/POST${aws_api_gateway_resource.proxy.path}"
  #source_arn = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/POST/"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*${aws_api_gateway_resource.proxy.path}"


}


#resource "aws_api_gateway_request_validator" "example" {
/* name                        = "example"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_body       = true
  validate_request_parameters = true
} */


/* resource "aws_api_gateway_authorizer" "demo" {
 name                   = "demo"
rest_api_id            = aws_api_gateway_rest_api.api.id
authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
authorizer_credentials = aws_iam_role.invocation_role.arn
} */

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




