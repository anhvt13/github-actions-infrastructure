locals {
  #=================================
  # IAM role management
  # ================================
  github_actions_iam_manage_role_statement = {
    Sid    = "IAMManageRoles"
    Effect = "Allow"
    Action = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:CreateInstanceProfile",
      "iam:ListInstanceProfilesForRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy"
    ]
    Resource = [
      "arn:aws:iam::249899229305:role/capstone-bastion-ssm-instant-role",
      "arn:aws:iam::249899229305:role/capstone-ecs-task-role",
      "arn:aws:iam::249899229305:role/capstone-ecs-task-execution-role",
      "arn:aws:iam::249899229305:role/driver-blue-green-hook-ecs-assume-role",
      "arn:aws:iam::249899229305:role/driver-blue-green-hook-execution-role",
      "arn:aws:iam::249899229305:role/ecs-invoke-alb-infras-role",
      "arn:aws:iam::249899229305:role/cognito-jwt-edge-auth-execution-role",
      "arn:aws:iam::249899229305:role/rds-proxy-role"
    ]
  }

  # =============================
  # IAM Bastion instance
  # =============================
  github_actions_iam_manage_instance_statement = {
    Sid    = "IAMManageInstanceProfile"
    Effect = "Allow"
    Action = [
      "iam:CreateInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:GetInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile"
    ]
    Resource = [
      "arn:aws:iam::249899229305:instance-profile/capstone-bastion-instance-profile"
    ]
  }
  # ===================================
  # IAM Policies Management
  # ===================================
  github_actions_iam_manage_policy_statement = {
    Sid    = "IAMManagePolicies"
    Effect = "Allow"
    Action = [
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]
    Resource = [
      "arn:aws:iam::249899229305:policy/bastion-*",
      "arn:aws:iam::249899229305:policy/capstone-ecs-*",
      "arn:aws:iam::249899229305:policy/capstone-rds-secret-access-policy"
    ]
  }

  # ========================
  # IAM pass role management
  # ========================
  github_actions_iam_pass_role_policy_management = {
    Sid    = "IAMPassRoles"
    Effect = "Allow"
    Action = [
      "iam:PassRole"
    ]
    Resource = [
      "arn:aws:iam::249899229305:role/capstone-bastion-ssm-role",
      "arn:aws:iam::249899229305:role/capstone-ecs-task-role",
      "arn:aws:iam::249899229305:role/capstone-ecs-task-execution-role",
      "arn:aws:iam::249899229305:role/capstone-bastion-ssm-instant-role",
      "arn:aws:iam::249899229305:role/driver-blue-green-hook-execution-role",
      "arn:aws:iam::249899229305:role/driver-blue-green-hook-ecs-assume-role",
      "arn:aws:iam::249899229305:role/ecs-invoke-alb-infras-role",
      "arn:aws:iam::249899229305:role/cognito-jwt-edge-auth-execution-role"
    ]
  }
}

resource "aws_iam_policy" "github_actions_capstone_iam_policy" {
  name        = "github-actions-capstone-iam-policy"
  description = "IAM role, policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_iam_manage_role_statement,
      local.github_actions_iam_manage_instance_statement,
      local.github_actions_iam_manage_policy_statement,
      local.github_actions_iam_pass_role_policy_management
    ]
  })
}
