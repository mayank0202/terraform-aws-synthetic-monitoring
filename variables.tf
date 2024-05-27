variable "use_default_role" {
  description = "Whether to use the default IAM role for canary execution. If true, it will use the default role. If false, users need to provide their own role ARN."
  type        = bool
  default     = true
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role for the canary execution. This is used if use_default_role is set to false."
  type        = string
  default     = ""
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
variable "enabled" {
  description = "Whether the KMS module is enabled. If true, a custom KMS key will be used for encryption. If false, the default AWS managed KMS key will be used."
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "Alias for the custom KMS key (if enabled)."
  type        = string
}

variable "protocol" {
  description = "The protocol for the SNS subscription endpoint."
  type        = string
  default     = "email"
}

variable "endpoint" {
  description = "The endpoint for the SNS subscription."
  type        = string
}
variable "iam_policy_name" {
  type        = string
  default     = "canary_execution_policy"
  description = "The name of the IAM policy for executing canaries."
}

///////// KMS //////////////////

variable "deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
}

# variable "alias" {
#   type        = string
#   description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash. If not specified, the alias name will be auto-generated."
# }

variable "custom_kms_policy" {
  description = "Custom KMS policy to apply if enabled. If not provided, a default policy will be used."
  type        = string
  default     = ""
}
variable "sns_topic_name" {
  description = "Name for the SNS topic."
  type        = string
}
variable "canaries_with_vpc" {
  description = "A map of canaries configurations with VPC"
  type        = map(any)
}

# variable "execution_role_arn" {
#   description = "The ARN of the IAM role for the canary"
#   type        = string
# }

variable "subnet_ids" {
  description = "List of subnet IDs where the canary will run"
  type        = list(string)
  default     = [""]
}

variable "security_group_ids" {
  description = "List of security group IDs for the canary"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "Tags to apply to the canary"
  type        = map(string)
}
