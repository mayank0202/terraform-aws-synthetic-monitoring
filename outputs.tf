output "canary_arns" {
  description = "ARNs of the created AWS Synthetics canaries"
  value       = values(aws_synthetics_canary.dynamic_canaries_with_vpc)[*].arn
}
