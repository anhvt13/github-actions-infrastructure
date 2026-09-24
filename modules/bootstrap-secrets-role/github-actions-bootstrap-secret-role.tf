//TODO - Run manually one time outside the Github action - avoid loop trust boundary depends
// Configuring an IAM role for trusted github-actions-infrastructure repository assuming
resource "aws_iam_role" "github-actions-bootstrap-secret-role" {
  name = "github-actions-bootstrap-secret-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github-actions.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:anhvt13@42229955/github-actions-infrastructure@1375902132:ref:refs/heads/main",
              "repo:anhvt13@42229955/github-actions-infrastructure@1375902132:environment:prod"
            ]
          }
        }
      }
    ]
  })
}

// Explicit least privilege policies for bootstrap TLS certificates
resource "aws_iam_role_policy" "github-actions-bootstrap-certs-policy" {
  name = "github-actions-bootstrap-certs-policy"
  role = aws_iam_role.github-actions-bootstrap-secret-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ========================
      # Least privilege on Capstone secrets value
      # ========================
      {
        Sid    = "SecretsManager"
        Effect = "Allow"
        Action = [
          "secretsmanager:PutSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bff/tls",
          "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/driver/tls",
          "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bff/oauth2"
        ]
      }
    ]
  })
}


