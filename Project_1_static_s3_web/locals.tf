
locals {
  s3_bucket_name_webapp = "udacity-webhosting-bucket-miro"
  source                = "./webapp"
  key                = "index.html"
  s3_policy_json_file = "./s3_bucket_policy.json"
}