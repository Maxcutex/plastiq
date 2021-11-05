locals {
  bucket_name = var.bucket_name != "" ? var.bucket_name : var.sub_domain_name
}

resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  acl    = "private"
  policy = data.aws_iam_policy_document.bucket_policy.json

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.sub_domain_name}"]
    max_age_seconds = 3000
  }
  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  force_destroy = var.s3_force_destroy

  tags = {
    "Name" = local.bucket_name
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "AllowReadFromAll"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# Refactor it to use loop
resource "aws_s3_bucket_object" "index" {
  bucket       = local.bucket_name
  key          = "index.html"
  source       = "website_files/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error" {
  bucket       = local.bucket_name
  key          = "error.html"
  source       = "website_files/error.html"
  content_type = "text/html"
}