### These are the outputs needed for configuring the QRadar log source

# Name of the queue
output "queue_url" {
  description = "SQS Queue for events"
  value       = aws_sqs_queue.qradar_queue.url
}

# Name of the key
output "access_key_id" {
  description = "AWS access key ID created for user"
  value       = aws_iam_access_key.qradar_key.id
}

# Value of the key
output "access_key_secret" {
  description = "AWS access key secret created for user"
  value       = nonsensitive(aws_iam_access_key.qradar_key.secret)
}
