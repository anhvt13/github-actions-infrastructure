locals {
  #==========================================
  # Elastic Load Balancer policies management
  # =========================================
  github_actions_elb_management_statement = {
    Sid    = "ElasticLoadBalancing"
    Effect = "Allow"
    Action = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListenerAttributes"
    ]
    Resource = "*"
  }
}

resource "aws_iam_policy" "github_actions_capstone_elb_policy" {
  name        = "github-actions-capstone-elb-policy"
  description = "Elastic load balancer policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_elb_management_statement
    ]
  })
}

