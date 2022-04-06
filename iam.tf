### Creating lambda role ###

resource "aws_iam_role" "lambda_role" {
  name               = "test_Lambda_Function_Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

### Creating lambda role policy ###

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role_test"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
     "Version" : "2012-10-17",
     "Statement" : [
         {
             "Sid" : "VisualEditor0",
             "Effect" : "Allow",
             "Action" : "s3:GetObject",
             "Resource" : "arn:aws:s3:::pocops/*"
         }
     ]
 }
 EOF
}
### Attach IAM Policy to IAM Role ###
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}
