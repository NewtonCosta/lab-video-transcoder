

provider "aws" {
  alias  = "mediaconvert"
  region = var.region

  endpoints {
    mediaconvert = var.mediaconvert_endpoint
  }
}

resource "aws_iam_role" "mediaconvert_role" {
  name = "${var.project_name}-mediaconvert-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "mediaconvert.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "mediaconvert_policy" {
  role = aws_iam_role.mediaconvert_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }]
  })
}

resource "aws_mediaconvert_job_template" "template" {
  provider = aws.mediaconvert

  name = "${var.project_name}-template"
  role = aws_iam_role.mediaconvert_role.arn

  settings_json = jsonencode({
    OutputGroups = [{
      Name = "File Group"
      OutputGroupSettings = {
        Type = "FILE_GROUP_SETTINGS"
        FileGroupSettings = {
          Destination = "s3://${var.bucket_name}/output/"
        }
      }
      Outputs = [{
        ContainerSettings = {
          Container = "MP4"
        }
        VideoDescription = {
          CodecSettings = {
            Codec = "H_264"
            H264Settings = {
              RateControlMode = "QVBR"
              MaxBitrate      = 5000000
            }
          }
        }
      }]
    }]
  })
}

output "role_arn" {
  value = aws_iam_role.mediaconvert_role.arn
}

output "job_template_name" {
  value = aws_mediaconvert_job_template.template.name
}
