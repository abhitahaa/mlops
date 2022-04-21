#variable "env" {}
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"

# }

/*
 resource "aws_s3_bucket" "testing" {
  bucket = "pocops"

  tags = {
    Name        = "tstops"
    Environment = "Sandy"
  }
}
resource "aws_s3_bucket_public_access_block" "testing" {
  bucket                  = aws_s3_bucket.testing.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_test" {

  bucket = aws_s3_bucket.testing.id
  versioning_configuration {
    status = "Disabled"

  }
}


resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.testing.id
  key    = "test"
  source = "/dev/null" 
}
*/
# Upload an object
#resource "aws_s3_bucket_object" "object" {

# bucket = aws_s3_bucket.b1.id

#key    = "profile"

#acl    = "private"  # or can be "public-read"

#source = "myfiles/yourfile.txt"

#etag = filemd5("myfiles/yourfile.txt")

#}

# to upload multiple files
#resource "aws_s3_bucket_object" "object1" {
#for_each = fileset("myfiles/", "*")
#bucket = aws_s3_bucket.b1.id
#key = each.value
#source = "myfiles/${each.value}"
#etag = filemd5("myfiles/${each.value}")
#}



