variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name to listen for object uploads"
  type        = string
}

variable "queue_arn" {
  description = "SQS queue ARN target"
  type        = string
}
