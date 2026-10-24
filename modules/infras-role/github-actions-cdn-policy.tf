locals {
  #==========================================
  # Cloudfront Policy Management
  #=========================================
  github_actions_cloudfront_management_statement = {
    Sid    = "Cloudfront"
    Effect = "Allow"
    Action = [
      "cloudfront:CreateDistribution",
      "cloudfront:TagResource",
      "cloudfront:GetDistribution"
    ]
    Resource = "arn:aws:cloudfront::249899229305:distribution/*"
  }
}
resource "aws_iam_policy" "github_actions_capstone_cdn_policy" {
  name        = "github-actions-capstone-cdn-policy"
  description = "Cloudfront policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_cloudfront_management_statement
    ]
  })
}


