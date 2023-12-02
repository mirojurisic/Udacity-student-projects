# # We need to have below resources for static web hosting
# # 1. S3 bucket
# # 2. CloudFront

# create s3 bucket
resource "aws_s3_bucket" "static_web" {
  bucket        = local.s3_bucket_name_webapp
  force_destroy = true
}

# public access to s3 bucket
resource "aws_s3_bucket_public_access_block" "static_web" {
  bucket = aws_s3_bucket.static_web.id
  # access control list
  block_public_acls = false
  # reject new policy
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.static_web.id
  policy = jsonencode(
    {
    "Version":"2012-10-17",
    "Statement":[
      {
        "Sid":"AddPerm",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::${aws_s3_bucket.static_web.bucket}/*"]
      }
    ]
  })

}
# static web hosting
resource "aws_s3_bucket_website_configuration" "udacity" {
  bucket = aws_s3_bucket.static_web.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }

}
# set cloudfront configuration
resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "site-access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
# set cloudfront distribution
resource "aws_cloudfront_distribution" "site_access" {
  enabled             = true
  default_root_object = local.key
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.static_web.id
    viewer_protocol_policy = "https-only"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name              = aws_s3_bucket.static_web.bucket_domain_name
    origin_id                = aws_s3_bucket.static_web.id
    origin_access_control_id = aws_cloudfront_origin_access_control.site_access.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN"]
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }


}

