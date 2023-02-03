### This file creates the resources needed for CloudTrail
### It creates a trail and a bucket
### It then configures the bucket permissions (deny public access, allow CloudTrail to write)
### It also creates a notification event so that the SQS queue is notified when new events are generated

# Create the trail
resource "aws_cloudtrail" "qradar_cloudtrail" {
  name           = var.trail_name
  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
}

# Create the bucket
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Create the bucket policy for CloudTrail access
resource "aws_s3_bucket_policy" "cloudtrail_bucketpolicy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "AWSCloudTrailAclCheck",
        Effect : "Allow",
        Principal : {
          Service : "cloudtrail.amazonaws.com"
        },
        Action : "s3:GetBucketAcl",
        Resource : "${aws_s3_bucket.cloudtrail_bucket.arn}"
      },
      {
        Sid : "AWSCloudTrailWrite",
        Effect : "Allow",
        Principal : {
          Service : "cloudtrail.amazonaws.com"
        },
        Action : "s3:PutObject"
        Resource : "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/*",
        Condition : {
          StringEquals : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Create the event notification to SQS object
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  queue {
    queue_arn = aws_sqs_queue.qradar_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

# Set the permissions for the bucket
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}