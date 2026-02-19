variable "project_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "queue_url" {
  type = string
}

variable "role_arn" {
  type        = string
  description = "MediaConvert IAM role ARN for jobs"
}

variable "job_template_name" {
  type        = string
  description = "Name of the MediaConvert stub JobTemplate"
}
