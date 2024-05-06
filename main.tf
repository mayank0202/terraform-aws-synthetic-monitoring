resource "aws_iam_role" "canary_execution_role" {
  count = var.use_default_role ? 0 : 1

  name = var.use_default_role ? "default-canary-execution-role" : "custom-canary-execution-role"

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
  count = var.use_default_role ? 0 : 1

  name        = var.use_default_role ? "" : var.iam_policy_name
  description = var.use_default_role ? "" : "Policy for executing canaries"

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
  count      = var.use_default_role ? 0 : 1
  role       = var.use_default_role ? aws_iam_role.canary_execution_role[0].name : var.execution_role_arn
  policy_arn = aws_iam_policy.canary_execution_policy[*].arn
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
  policy = var.sns_topic_policy
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}

resource "aws_synthetics_canary" "dynamic_canaries_with_vpc" {
  for_each = var.canaries_with_vpc

  name                     = each.value.name
  artifact_s3_location     = each.value.artifact_s3_location
  execution_role_arn       = var.execution_role_arn
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
    environment_variables = each.value.environment_variables
  }

  #   depends_on = [data.archive_file.init]
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

  alarm_actions     = [var.sns_topic_arn]
  alarm_description = "Canary is down: ${each.value.name}"
  tags              = var.tags
}
