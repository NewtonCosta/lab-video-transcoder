resource "aws_s3_bucket" "this" {
  bucket = "${var.project_name}-bucket"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "eventbridge" {
  bucket      = aws_s3_bucket.this.id
  eventbridge = true
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
