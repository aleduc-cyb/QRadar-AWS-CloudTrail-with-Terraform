# Create the trail
resource "aws_cloudtrail" "qradar_cloudtrail" {
  name           = var.trail_name
  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id
  #s3_key_prefix                 = "prefix"
  include_global_service_events = true
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

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

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  queue {
    queue_arn = aws_sqs_queue.qradar_queue.arn
    events    = ["s3:ObjectCreated:*"]
    #filter_suffix = ".log"
  }
}