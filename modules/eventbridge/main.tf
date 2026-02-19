resource "aws_cloudwatch_event_rule" "s3_upload" {
  name = "${var.project_name}-s3-rule"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [var.bucket_name]
      }
      object = {
        key = [{
          prefix = "input/"
        }]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "sqs" {
  rule      = aws_cloudwatch_event_rule.s3_upload.name
  target_id = "SendToSQS"
  arn       = var.queue_arn
}
