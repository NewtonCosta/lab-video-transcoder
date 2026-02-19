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
  region       = var.region
}

module "lambda" {
  source                = "./modules/lambda"
  project_name          = var.project_name
  bucket_name           = module.s3.bucket_name
  queue_arn             = module.sqs.queue_arn
  queue_url             = module.sqs.queue_url
  mediaconvert_role_arn = module.mediaconvert.role_arn
  job_template_name     = module.mediaconvert.job_template_name
}

module "eventbridge" {
  source       = "./modules/eventbridge"
  project_name = var.project_name
  bucket_name  = module.s3.bucket_name
  queue_arn    = module.sqs.queue_arn
}
