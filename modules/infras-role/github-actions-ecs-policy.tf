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

  github_actions_application_autoscaling_statement = {
    Sid    = "AppAutoScaling"
    Effect = "Allow"
    Action = [
      "application-autoscaling:RegisterScalableTarget"
    ]
    Resource = "arn:aws:application-autoscaling:ap-southeast-1:249899229305:scalable-target/*"
  }

  github_actions_service_link_role_statement = {
    "Sid" : "AllowECSApplicationAutoScalingServiceLinkedRole",
    "Effect" : "Allow",
    "Action" : "iam:CreateServiceLinkedRole",
    "Resource" : "arn:aws:iam::*:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService",
    "Condition" : {
      "StringLike" : {
        "iam:AWSServiceName" : "ecs.application-autoscaling.amazonaws.com"
      }
    }
  }

}

resource "aws_iam_policy" "github_actions_capstone_ecs_policy" {
  name        = "github-actions-capstone-ecs-policy"
  description = "ECS, service discovery, application autoscaling policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_ecs_management_statement,
      local.github_actions_service_discovery_statement,
      local.github_actions_application_autoscaling_statement,
      local.github_actions_service_link_role_statement
    ]
  })
}
