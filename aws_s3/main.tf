provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "learn-terraform-bucket" {
  bucket = "learn-terraform-bucket-mannmae"
  
  tags = {
    environment = "devel"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.learn-terraform-bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "learn-terraform-sample-txt" {
  bucket = aws_s3_bucket.learn-terraform-bucket.id
  key = "sample.txt"
  source = "sample.txt"
}

resource "aws_s3_bucket_policy" "bucket-ploicy" {
  bucket = aws_s3_bucket.learn-terraform-bucket.id

  depends_on = [ 
    aws_s3_bucket_public_access_block.public-access
   ]

   policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicRead",
      "Effect":"Allow",
      "Principal":"*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.learn-terraform-bucket.id}/*"]
    }
  ]
}
POLICY
}