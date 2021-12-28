resource "aws_s3_bucket" "this" {
  for_each = toset(var.s3_for_gitlab)
  bucket = format("%s.%s.gitlab.%s.s3", var.prefix, var.vpc_name, each.key)
  acl = "private"
  tags = merge(var.tags, tomap({Name = format("%s.%s.gitlab.%s.s3", var.prefix, var.vpc_name, each.key)}))
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = toset(var.s3_for_gitlab)
  bucket = format("%s.%s.gitlab.%s.s3", var.prefix, var.vpc_name, each.key)
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket.this
  ]
}