### This file creates the SQS queue to manage the events
### The policy is set so that only the bucket can send messages to this queue

resource "aws_sqs_queue" "qradar_queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = 60
  max_message_size           = 2048
  message_retention_seconds  = 1209600

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : "*",
        Action : "sqs:SendMessage",
        Resource : "arn:aws:sqs:*:*:s3-event-notification-queue",
        Condition : {
          ArnEquals : { "aws:SourceArn" : "${aws_s3_bucket.cloudtrail_bucket.arn}" }
        }
      },
      {
        Effect : "Allow",
        Principal : {
          Service : "s3.amazonaws.com"
        },
        Action : [
          "SQS:SendMessage"
        ],
        Resource : "arn:aws:sqs:${var.region}:${local.account_id}:${var.queue_name}",
        Condition : {
          ArnLike : {
            "aws:SourceArn" : "arn:aws:s3:*:*:${aws_s3_bucket.cloudtrail_bucket.bucket}"
          },
          StringEquals : {
            "aws:SourceAccount" : "${local.account_id}"
          }
        }
      }
    ]
  })
}