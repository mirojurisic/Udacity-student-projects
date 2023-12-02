output "cf_web_url" {
  value = aws_cloudfront_distribution.site_access.domain_name
}

output "s3_web_url" {
  value = aws_s3_bucket.static_web.bucket_regional_domain_name 
}