locals {
  #==========================================
  # RDS Policy Management
  #=========================================
  github_actions_rds_management_statement = {
    Sid    = "Rds"
    Effect = "Allow"
    Action = [
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:CreateDBCluster",
      "rds:DeleteDBCluster",
      "rds:DescribeDBClusters",
      "rds:ModifyDBCluster",
      "rds:CreateDBInstance",
      "rds:DeleteDBInstance",
      "rds:DescribeDBInstances",
      "rds:ModifyDBInstance",
      "rds:CreateDBSubnetGroup",
      "rds:DeleteDBSubnetGroup",
      "rds:DescribeDBSubnetGroups",
      "rds:ModifyDBSubnetGroup",
      "rds:ListTagsForResource",
      "rds:DescribeGlobalClusters"
    ]
    Resource = "*"
  }

  #==========================================
  # RDS Proxy Management
  #=========================================
  github_actions_rds_proxy_management_statement = {
    Sid    = "RdsProxy"
    Effect = "Allow"
    Action = [
      "rds:CreateDBProxy",
      "rds:DescribeDBProxies",
      "rds:DeleteDBProxy",
      "rds:ModifyDBProxyTargetGroup",
      "rds:DescribeDBProxyTargetGroups",
      "rds:DescribeDBProxyTargets"
    ]
    Resource = "arn:aws:rds:ap-southeast-1:249899229305:db-proxy:*"
  }

  #==========================================
  # RDS Proxy Target Group Management
  #=========================================
  github_actions_rds_proxy_target_group_management_statement = {
    Sid    = "RdsProxyTargetGroup"
    Effect = "Allow"
    Action = [
      "rds:ModifyDBProxyTargetGroup",
      "rds:RegisterDBProxyTargets"
    ]
    Resource = "arn:aws:rds:ap-southeast-1:249899229305:target-group:*"
  }

  #==========================================
  # RDS Proxy Register Management
  #=========================================
  github_actions_rds_proxy_register_management_statement = {
    Sid    = "RdsProxyRegister"
    Effect = "Allow"
    Action = [
      "rds:RegisterDBProxyTargets"
    ]
    Resource = "arn:aws:rds:ap-southeast-1:249899229305:cluster:capstone-aurora-cluster"
  }

  # ===========================
  # ElastiCache  Valkey
  # ===========================
  github_actions_elastic_cache_statement = {
    Sid    = "ElastiCache"
    Effect = "Allow"
    Action = [
      "elasticache:CreateServerlessCache",
      "elasticache:DeleteServerlessCache",
      "elasticache:DescribeServerlessCaches",
      "elasticache:ModifyServerlessCache",
      "elasticache:TagResource",
      "elasticache:UntagResource",
      "elasticache:ListTagsForResource",
      "elasticache:AddTagsToResource",
    ]
    Resource = "*"
  }

  # =================
  # Secrets Manager
  # =================
  github_actions_secret_manager_statement = {
    Sid    = "SecretsManager"
    Effect = "Allow"
    Action = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
      "secretsmanager:GetResourcePolicy"
    ]
    Resource = [
      "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bff/tls-*",
      "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/driver/tls-*",
      "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bff/oauth2-*",
      "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bg/tls-*"
    ]
  }

  # ===========================
  # Secrets Manager for RDS
  # ===========================
  github_actions_secret_rds_manager_statement = {
    Sid    = "RdsSecret"
    Effect = "Allow"
    Action = [
      "secretsmanager:CreateSecret",
      "secretsmanager:TagResource"
    ]
    Resource = "*"
  }

  # ====================
  # KMS
  # ====================
  github_actions_kms_permision_statement = {
    Sid    = "Kms"
    Effect = "Allow"
    Action = [
      "kms:DescribeKey"
    ]
    Resource = "*"
  }
}

resource "aws_iam_policy" "github_actions_capstone_data_policy" {
  name        = "github-actions-capstone-data-policy"
  description = "RDS, Elastic cache, Secret Manager, KMS permission policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_rds_management_statement,
      local.github_actions_elastic_cache_statement,
      local.github_actions_secret_manager_statement,
      local.github_actions_secret_rds_manager_statement,
      local.github_actions_kms_permision_statement,
      local.github_actions_rds_proxy_management_statement,
      local.github_actions_rds_proxy_target_group_management_statement,
      local.github_actions_rds_proxy_register_management_statement
    ]
  })
}


