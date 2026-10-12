locals {
  #=================================
  # ECS management
  # ================================
  github_actions_ecs_management_statement = {
    Sid    = "Ecs"
    Effect = "Allow"
    Action = [
      "ecs:CreateCluster",
      "ecs:DeleteCluster",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:CreateService",
      "ecs:DeleteService",
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:TagResource",
      "ecs:UntagResource",
      "ecs:ListTagsForResource",
      "ecs:PutClusterCapacityProviders",
      "ecs:UpdateCluster"
    ]
    Resource = "*"
  }

  # =====================================
  # Service Discovery
  # =====================================
  github_actions_service_discovery_statement = {
    Sid    = "ServiceDiscovery"
    Effect = "Allow"
    Action = [
      "servicediscovery:CreatePrivateDnsNamespace",
      "servicediscovery:DeleteNamespace",
      "servicediscovery:GetNamespace",
      "servicediscovery:GetOperation",
      "servicediscovery:ListNamespaces",
      "servicediscovery:TagResource",
      "servicediscovery:UntagResource",
      "servicediscovery:ListTagsForResource"
    ]
    Resource = "*"
  }
}

resource "aws_iam_policy" "github_actions_capstone_ecs_policy" {
  name        = "github-actions-capstone-ecs-policy"
  description = "ECS, service discovery policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_ecs_management_statement,
      local.github_actions_service_discovery_statement
    ]
  })
}
