locals {
  kms_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudWatchToAccessTheKey",
        Effect    = "Allow",
        Principal = { Service = "cloudwatch.amazonaws.com" },
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:UpdateKeyPolicy",
        ],
        Resource = "*",
      },
      {
        Sid       = "AllowKeyOwnerToUpdate",
        Effect    = "Allow",
        Principal = { AWS = data.aws_caller_identity.current.account_id },
        Action    = "kms:*",
        Resource  = "*",
      },
    ],
  })
}
