//TODO-Register Github action as an OIDC connect provider with aws STS
resource "aws_iam_openid_connect_provider" "github-actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
}

//TODO-Configuring an IAM role for bff service deployment with trusted "capstone-bff-client" repository assuming
resource "aws_iam_role" "github-actions-bff-deployment-role" {
  name = "github-actions-bff-deployment-role"
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
            "token.actions.githubusercontent.com:sub" = "repo:anhvt13@42229955/capstone-bff-client@1374533695:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

//TODO-Explicitly least-privilege on ECR push image permission
resource "aws_iam_role_policy" "github-actions-bff-ecr-push-policy" {
  name = "github-actions-bff-ecr-push-policy"
  role = aws_iam_role.github-actions-bff-deployment-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EcrAuth"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Sid    = "EcrPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage"
        ]
        Resource = "arn:aws:ecr:ap-southeast-1:249899229305:repository/capstone/bff-client"
      }
    ]
  })
}

//TODO-Explicitly least-privilege on ECS deployment permission
resource "aws_iam_role_policy" "github-actions-bff-ecs-deploy-policy" {
  name = "github-actions-bff-ecs-deploy-policy"
  role = aws_iam_role.github-actions-bff-deployment-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EcsDeployment"
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Resource = [
          "arn:aws:ecs:ap-southeast-1:249899229305:service/capstone-ecs-cluster/bff-client"
        ]
      }
    ]
  })
}

//TODO-Explicitly least-privilege on render ECS task definition permission
resource "aws_iam_role_policy" "github-actions-bff-ecs-task-definition-policy" {
  name = "github-actions-bff-ecs-task-definition-policy"
  role = aws_iam_role.github-actions-bff-deployment-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DescribeTaskDefinition"
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Sid    = "RegisterTaskDefinition"
        Effect = "Allow"
        Action = [
          "ecs:RegisterTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Sid    = "PassRolesInTaskDefinition"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          data.aws_iam_role.capstone-ecs-task-role.arn,
          data.aws_iam_role.capstone-ecs-task-execution-role.arn
        ]
      }
    ]
  })
}


