variable "region" {
  type        = string
  description = "Region in which to create the resources"
  default     = "us-east-1"
}

variable "qradar_user" {
  type        = string
  description = "Name of the user to create"
  default     = "qradarlogs"
}

variable "qradar_group" {
  type        = string
  description = "Name of the group to create"
  default     = "qradargroup"
}

variable "qradar_policy" {
  type        = string
  description = "Name of the policy to create"
  default     = "qradarpolicy"
}

variable "bucket_name" {
  type        = string
  description = "Name of the bucket in which to drop logs"
  default     = "cloudtrailbucket1684648786"
}

variable "queue_name" {
  type        = string
  description = "Name of the SQS Queue"
  default     = "cloudtrailsqsqueue"
}

variable "trail_name" {
  type        = string
  description = "Name of the CloudTrail trail created"
  default     = "qradartrail"
}