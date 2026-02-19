module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "sqs" {
  source       = "./modules/sqs"
  project_name = var.project_name
}

module "mediaconvert" {
  source       = "./modules/mediaconvert"
  project_name = var.project_name
  bucket_name  = module.s3.bucket_name
}

module "mediaconvert_lambda" {
  source            = "./modules/lambda"
  project_name      = var.project_name
  bucket_name       = aws_s3_bucket.media_bucket.bucket
  queue_url         = aws_sqs_queue.mediaconvert_queue.id # <-- pass SQS URL, not ARN
  role_arn          = module.mediaconvert.role_arn        # MediaConvert IAM role
  job_template_name = module.mediaconvert.job_template_name
}

module "eventbridge" {
  source       = "./modules/eventbridge"
  project_name = var.project_name
  bucket_name  = module.s3.bucket_name
  queue_arn    = module.sqs.queue_arn
}
