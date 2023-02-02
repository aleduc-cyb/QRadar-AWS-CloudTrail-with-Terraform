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
