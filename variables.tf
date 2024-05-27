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
################################################################################
## S3
################################################################################

variable "allow_encrypted_uploads_only" {
  type        = bool
  default     = false
  description = "Set to `true` to prevent uploads of unencrypted objects to S3 bucket"
}

variable "user_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to create an IAM user with permission to access the bucket"
}
variable "bucket_name" {
  type        = string
  description = ""
}
variable "bucket_key_enabled" {
  type        = bool
  description = ""
  default = false
}
variable "allowed_bucket_actions" {
  type = list(string)
  default = []
  description = ""
}
variable "acl" {
  type = string
  default = "private"
  description = ""
}
variable "force_destroy" {
  type = bool
  default = true
  description = ""
}
variable "versioning_enabled" {
  type = bool
  default = false
  description = ""
}
variable "block_public_acls" {
  type = bool
  default = false
  description = ""
}
variable "block_public_policy" {
  type = bool
  default = false
  description = ""
}
variable "restrict_public_buckets" {
  type = bool
  default = false
  description = ""
}
variable "cors_configuration" {
  type = list(object({
    allowed_headers = list(string)
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers  = list(string)
      max_age_seconds = number
  }))
  default = []
  description = ""
}
variable "lifecycle_configuration_rules" {
  type = list(object({
    abort_incomplete_multipart_upload_days = number
      enabled                                = bool
      expiration = object({
        days                         = number
        expired_object_delete_marker = bool
      })
      filter_and = object({})
      id         = string
      noncurrent_version_expiration = object({
        newer_noncurrent_versions = number
        noncurrent_days           = number
      })
      noncurrent_version_transition = list(object({}))
      transition = list(object({
        days          = number
        storage_class = string
      }))
  }))
  default = [ {
    
      
        abort_incomplete_multipart_upload_days = 1
        enabled                                = true
        expiration = {
          days                         = null
          expired_object_delete_marker = null
        }

        # filter
        filter_and = {}
        id         = "delete after 365 days"
        noncurrent_version_expiration = {
          newer_noncurrent_versions = 1
          noncurrent_days           = 1
        }
        noncurrent_version_transition = []
        transition                    = []
    
  } ]
}
variable "access_key_enabled" {
  type = bool
  default = true
}
# variable "s3_buckets" {
#   type = list(object({
  
    
#     website_configuration = list(object({
#       index_document = string
#       error_document = string
#       routing_rules = list(object({
#         condition = object({
#           http_error_code_returned_equals = string
#           key_prefix_equals               = string
#         })
#         redirect = object({
#           host_name               = string
#           http_redirect_code      = string
#           protocol                = string
#           replace_key_prefix_with = string
#           replace_key_with        = string
#         })
#       }))
#     }))
#     access_key_enabled = bool
#   }))
#   default = [ {
#     bucket_name             = "sf-arc-synthetics-artifacts"
#     bucket_key_enabled      = false
#     allowed_bucket_actions  = []
#     acl                     = "private"
#     force_destroy           = true
#     block_public_acls       = true
#     block_public_policy     = true
#     ignore_public_acls      = true
#     restrict_public_buckets = true
#     versioning_enabled      = false
#     cors_configuration      = []
#     lifecycle_configuration_rules = [
#       {
#         abort_incomplete_multipart_upload_days = 1
#         enabled                                = true
#         expiration = {
#           days                         = null
#           expired_object_delete_marker = null
#         }

#         # filter
#         filter_and = {}
#         id         = "delete after 365 days"
#         noncurrent_version_expiration = {
#           newer_noncurrent_versions = 1
#           noncurrent_days           = 1
#         }
#         noncurrent_version_transition = []
#         transition                    = []

#       },
#     ]
#     website_configuration = []
#     access_key_enabled    = true
#   } ]
# }

variable "sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}
