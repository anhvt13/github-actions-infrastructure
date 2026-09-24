// Configuring an IAM role for trusted github driver service repo subject
resource "aws_iam_role" "github-actions-driver-deployment-role" {
  name = "github-actions-driver-deployment-role"
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
            "token.actions.githubusercontent.com:sub" = "repo:anhvt13@42229955/capstone-driver-service@1375324951:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

// Explicitly the least-privilege ECR push image policy on driver-service repository
resource "aws_iam_role_policy" "github-actions-driver-ecr-push-policy" {
  name = "github-actions-driver-ecr-push-policy"
  role = aws_iam_role.github-actions-driver-deployment-role.id
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
        Resource = "arn:aws:ecr:ap-southeast-1:249899229305:repository/capstone/driver-service"
      }
    ]
  })
}

// Explicitly the least-privilege ECS deployment permissions for driver-service
resource "aws_iam_role_policy" "github-actions-driver-ecs-deploy-policy" {
  name = "github-actions-driver-ecs-deploy-policy"
  role = aws_iam_role.github-actions-driver-deployment-role.id
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
          "arn:aws:ecs:ap-southeast-1:249899229305:service/capstone-ecs-cluster/driver-service"
        ]
      }
    ]
  })
}

//Explicitly the least-privilege from GitHub on ECS task definition policy
resource "aws_iam_role_policy" "github-actions-driver-ecs-task-definition-policy" {
  name = "github-actions-driver-ecs-task-definition-policy"
  role = aws_iam_role.github-actions-driver-deployment-role.id
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
