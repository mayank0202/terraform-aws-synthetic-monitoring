# terraform-aws-synthetic-monitoring

# AWS Synthetics Canary Module

This module creates AWS Synthetics canaries with VPC configurations.

## Features

- Allows creation of AWS Synthetics canaries with VPC configurations.
- Supports custom IAM roles and policies.
- Flexible configuration options for canaries.

## Usage

```hcl
module "synthetics_canaries" {
  source = "your-module-source"

  # Insert input variables here
  canaries_with_vpc = var.canaries_with_vpc
  execution_role_arn = var.execution_role_arn
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  tags = var.tags
}

```

Feel free to adjust the content according to your specific module and project details!

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0, < 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | sourcefuse/arc-kms/aws | 0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.canary_in_vpc_alarms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_policy.canary_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.canary_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.canary_execution_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.my_sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.my_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_synthetics_canary.dynamic_canaries_with_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_canaries_with_vpc"></a> [canaries\_with\_vpc](#input\_canaries\_with\_vpc) | A map of canaries configurations with VPC | `map(any)` | `{}` | no |
| <a name="input_custom_kms_policy"></a> [custom\_kms\_policy](#input\_custom\_kms\_policy) | Custom KMS policy to apply if enabled. If not provided, a default policy will be used. | `string` | `""` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource | `number` | `10` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the KMS module is enabled. If true, a custom KMS key will be used for encryption. If false, the default AWS managed KMS key will be used. | `bool` | `false` | no |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | The endpoint for the SNS subscription. | `string` | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The ARN of the IAM role for the canary execution. This is used if use\_default\_role is set to false. | `string` | `""` | no |
| <a name="input_iam_policy_name"></a> [iam\_policy\_name](#input\_iam\_policy\_name) | The name of the IAM policy for executing canaries. | `string` | `"canary_execution_policy"` | no |
| <a name="input_kms_key_alias"></a> [kms\_key\_alias](#input\_kms\_key\_alias) | Alias for the custom KMS key (if enabled). | `string` | n/a | yes |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol for the SNS subscription endpoint. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the canary | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | ARN of the SNS topic to send alarms. | `string` | n/a | yes |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name for the SNS topic. | `string` | n/a | yes |
| <a name="input_sns_topic_policy"></a> [sns\_topic\_policy](#input\_sns\_topic\_policy) | The policy to apply to the SNS topic. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs where the canary will run | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the canary | `map(string)` | n/a | yes |
| <a name="input_use_default_role"></a> [use\_default\_role](#input\_use\_default\_role) | Whether to use the default IAM role for canary execution. If true, it will use the default role. If false, users need to provide their own role ARN. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_canary_arns"></a> [canary\_arns](#output\_canary\_arns) | ARNs of the created AWS Synthetics canaries |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
