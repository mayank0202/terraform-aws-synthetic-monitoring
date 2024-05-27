module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.project_name

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/synthetics"
  }
}
module "synthetic-monitoring" {
  source            = "../"
  sns_topic_name    = "poc-canary"
  tags              = module.tags.tags
  endpoint          = "mayank.sharma@sourcefuse.com"
  kms_key_alias     = "alias/synthetic-key"
  canaries_with_vpc = local.canaries_with_vpc
  bucket_name       = "sf-arc-synthetics-mayank"
}
