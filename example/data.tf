# Archive a single file.
data "archive_file" "init" {
  type        = "zip"
  source_dir  = "${path.module}/python-synthetics/canary1/"
  output_path = "${path.module}/python-synthetics/canary1.zip"
}
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Name"

    values = [
      "arc-poc-private-subnet-private-us-east-1b",
      "arc-poc-private-subnet-private-us-east-1a"
    ]
  }
}
