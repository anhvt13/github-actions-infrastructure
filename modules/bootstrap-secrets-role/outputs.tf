output "github_oidc_provider_arn" {
  description = "The public IP address of the EC2 instance"
  value       = aws_iam_openid_connect_provider.github-actions.arn
}
