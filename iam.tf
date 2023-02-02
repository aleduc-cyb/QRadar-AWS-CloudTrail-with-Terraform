# Get the account ID
data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

# Create a user
resource "aws_iam_user" "qradar_user" {
  name = var.qradar_user
}

# Create a group
resource "aws_iam_group" "qradar_group" {
  name = var.qradar_group
}

# Create a policy
resource "aws_iam_policy" "qradar_policy" {
  name = var.qradar_policy

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}/AWSLogs/*",
          "arn:aws:sqs:${var.region}:${local.account_id}:${aws_sqs_queue.qradar_queue.name}"
        ]
      },
    ]
  })
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "qradar_attach_policy" {
  group      = aws_iam_group.qradar_group.name
  policy_arn = aws_iam_policy.qradar_policy.arn
}

# Create an access key for this uesr
resource "aws_iam_access_key" "qradar_key" {
  user = aws_iam_user.qradar_user.name
}