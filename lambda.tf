data "archive_file" "zip_the_python_code" {
type        = "zip"
source_file = "${path.module}/test.py"
output_path = "${path.module}/python/lambda.zip"
}
resource "aws_lambda_function" "terraform_lambda_func" {
  filename                       = "${path.module}/python/lambda.zip"
  function_name                  = "Automate_next_Lambda_Function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "index.lambda_handler"
  runtime                        = "python3.8"
  source_code_hash = filebase64sha256("/python/lambda.zip")
  
}
