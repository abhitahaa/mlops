
resource "aws_iam_role" "s3_role" {
  name               = "test_movess3_Role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "s3.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

### Creating role policy ###

resource "aws_iam_policy" "iam_policy_for_s3" {

  name        = "aws_iam_policy_for_test_move_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
     "Version" : "2012-10-17",
     "Statement" : [
         {
             "Sid" : "VisualEditor0",
             "Effect" : "Allow",
             "Action" : [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListObject"
            ],
             "Resource" : "arn:aws:s3:::pocops/*"
         }
     ]
 }
 EOF
}
### Attach IAM Policy to IAM Role ###
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role_test" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.iam_policy_for_s3.arn
}
