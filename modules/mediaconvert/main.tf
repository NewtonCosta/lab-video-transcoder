resource "aws_iam_role" "mediaconvert_role" {
  name = "${var.project_name}-mediaconvert-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "mediaconvert.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "mediaconvert_policy" {
  role = aws_iam_role.mediaconvert_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
      Resource = ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
    }]
  })
}

resource "aws_cloudformation_stack" "mediaconvert_job_template" {
  name          = "${var.project_name}-mediaconvert-template"
  template_body = file("${path.module}/mediaconvert-job-template.yaml")

  parameters = {
    BucketName       = var.bucket_name
    ProjectName      = var.project_name
    MediaConvertRole = aws_iam_role.mediaconvert_role.arn
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]
}

output "role_arn" {
  value = aws_iam_role.mediaconvert_role.arn
}

output "job_template_name" {
  value = aws_cloudformation_stack.mediaconvert_job_template.outputs["MediaConvertJobTemplate"]
}
