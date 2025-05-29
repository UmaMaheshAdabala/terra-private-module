resource "aws_s3_bucket" "my_s3" {
  bucket        = var.bucket_name
  tags          = var.s3_tags
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my_s3" {
  bucket                  = aws_s3_bucket.my_s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_s3" {
  bucket     = aws_s3_bucket.my_s3.id
  depends_on = [aws_s3_bucket_ownership_controls.my_s3, aws_s3_bucket_public_access_block.my_s3]
  acl        = "public-read"

}

resource "aws_s3_bucket_policy" "my_s3" {
  bucket = aws_s3_bucket.my_s3.id
  policy = <<EOF
  {
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": [
              "s3:GetObject"
          ],
          "Resource": [
              "arn:aws:s3:::${var.bucket_name}/*"
          ]
      }
  ]
  }
  EOF
}
