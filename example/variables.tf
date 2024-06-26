################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "arc"
}
variable "environment" {
  type        = string
  default     = "poc"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}
variable "namespace" {
  type        = string
  description = "Namespace for the resources."
  default     = "arc"
}
# variable "artifact_s3_location" {
#   type        = string
#   description = "Location in Amazon S3 where Synthetics stores artifacts from the test runs of this canary."
#   default     = "arc-poc-synthetics-one"
# }