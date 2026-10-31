terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

//TODO: Configuring IAM role for infrastructure deployment trusted "capstone-infrastructure" Git repository
resource "aws_iam_role" "github-actions-infrastructure-deployment-role" {
  name = "github-actions-infrastructure-deployment-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::249899229305:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:ref:refs/heads/main",
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:pull_request",
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:environment:prod"
            ]
          }
        }
      }
    ]
  })
}

//TODO: Attachment least privilege policies for "github-actions-infrastructure-deployment-role"
resource "aws_iam_role_policy_attachment" "network-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_network_policy.arn
}

resource "aws_iam_role_policy_attachment" "iam-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_iam_policy.arn
}

resource "aws_iam_role_policy_attachment" "data-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_data_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_ecs_policy.arn
}

resource "aws_iam_role_policy_attachment" "elb-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_elb_policy.arn
}

resource "aws_iam_role_policy_attachment" "operation-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_operation_policy.arn
}

resource "aws_iam_role_policy_attachment" "cdn-policy-attachment" {
  role       = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy_arn = aws_iam_policy.github_actions_capstone_cdn_policy.arn
}





