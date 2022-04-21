resource "aws_iam_role" "apigateway_role" {
  name               = "newtestapigatewayRole"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                    ,
                    "apigateway.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_for_apigateway" {

  name        = "newtest_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


### Attach IAM Policy to IAM Role ###
resource "aws_iam_role_policy_attachment" "attach_iam_policyattachest" {
  role       = aws_iam_role.apigateway_role.name
  policy_arn = aws_iam_policy.iam_policy_for_apigateway.arn
}


data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/python/lambda_function.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename         = "${path.module}/python/lambda_function.zip"
  function_name    = "updated_Lambda_Function"
  role             = aws_iam_role.apigateway_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256

}


