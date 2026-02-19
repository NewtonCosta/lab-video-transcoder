variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name for input/output"
  type        = string
}

variable "queue_arn" {
  description = "SQS queue ARN"
  type        = string
}

variable "queue_url" {
  description = "SQS queue URL"
  type        = string
}

variable "mediaconvert_role_arn" {
  description = "IAM role ARN for MediaConvert jobs"
  type        = string
}

variable "job_template_name" {
  description = "MediaConvert job template name"
  type        = string
}
