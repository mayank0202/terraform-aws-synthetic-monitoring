resource "aws_iam_role" "canary_execution_role" {
  name = "default-canary-execution-role" // use random pet name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "canary_execution_policy" {
  name        = "poc-policy"
  description = "Policy for executing canaries"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*",
          "s3-object-lambda:*",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "canary_execution_attachment" {
  role       = aws_iam_role.canary_execution_role.name
  policy_arn = aws_iam_policy.canary_execution_policy.arn
}

/////////////////--KMS-KEY----//////////////////////////////
module "kms" {
  source                  = "sourcefuse/arc-kms/aws"
  version                 = "0.0.4"
  enabled                 = var.enabled
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  alias                   = var.kms_key_alias
  tags                    = var.tags
  policy                  = var.custom_kms_policy != "" ? var.custom_kms_policy : local.kms_policy
}

/////////////////--SNS----//////////////////////////////

resource "aws_sns_topic" "alarm" {
  name              = var.sns_topic_name
  kms_master_key_id = var.enabled ? module.kms.key_arn : null
  tags              = var.tags
}

resource "aws_sns_topic_policy" "my_sns_topic_policy" {
  arn    = aws_sns_topic.alarm.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}
resource "aws_synthetics_canary" "dynamic_canaries_with_vpc" {
  for_each = var.canaries_with_vpc

  name                     = each.value.name
  artifact_s3_location     = "s3://${module.s3_bucket.bucket_id}/"
  execution_role_arn       = data.aws_iam_role.execution_role.arn
  handler                  = each.value.handler
  zip_file                 = each.value.zip_file
  runtime_version          = each.value.runtime_version
  start_canary             = each.value.start_canary
  failure_retention_period = each.value.failure_retention_period
  success_retention_period = each.value.success_retention_period

  schedule {
    expression = each.value.schedule_expression
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  run_config {
    timeout_in_seconds    = 120
    environment_variables = each.value.environment_variables
  }

  depends_on = [module.s3_bucket]
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "canary_in_vpc_alarms" {
  for_each = var.canaries_with_vpc

  alarm_name          = "${each.value.name}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Failed"
  namespace           = "CloudWatchSynthetics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  actions_enabled     = true

  dimensions = {
    CanaryName = each.value.name
  }

  alarm_actions     = [aws_sns_topic.alarm.arn]
  alarm_description = "Canary is down: ${each.value.name}"
  tags              = var.tags
}

////////////////// s3 ////////////////////////

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "4.2.0"

  # for_each                      = { for x in var.s3_buckets : x.bucket_name => x }
  lifecycle_configuration_rules = var.lifecycle_configuration_rules
  bucket_name                   = var.bucket_name
  bucket_key_enabled            = var.bucket_key_enabled
  allowed_bucket_actions        = var.allowed_bucket_actions
  user_enabled                  = var.user_enabled
  block_public_acls             = var.block_public_acls
  block_public_policy           = var.block_public_policy
  # ignore_public_acls            = var.ignore_public_acls
  restrict_public_buckets       = var.restrict_public_buckets
  acl                           = var.acl
  force_destroy                 = var.force_destroy
  versioning_enabled            = var.versioning_enabled
  allow_encrypted_uploads_only  = var.allow_encrypted_uploads_only
  access_key_enabled            = var.access_key_enabled
  # website_configuration         = var.website_configuration
  cors_configuration            = var.cors_configuration
  sse_algorithm                 = var.sse_algorithm
  kms_master_key_arn            = module.kms.key_arn

  tags = var.tags
}