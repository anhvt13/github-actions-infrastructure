locals {
  #==========================================
  # CloudWatch Logs
  #=========================================
  github_actions_cloudwatch_logs_statement = {
    Sid    = "CloudWatchLogs"
    Effect = "Allow"
    Action = [
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource"
    ]
    Resource = [
      "arn:aws:logs:ap-southeast-1:249899229305:log-group::log-stream",
      "arn:aws:logs:ap-southeast-1:249899229305:log-group:/ecs/capstone-app"
    ]
  }

  # ===========================
  # CLoudWatch Describe
  # ===========================
  github_actions_cloudwatch_describe_statement = {
    Sid    = "CloudWatchLogsDescribe"
    Effect = "Allow"
    Action = [
      "logs:DescribeLogGroups"
    ]
    Resource = "*"
  }

  # =================
  # DB schema bucket
  # =================
  github_actions_db_schema_bucket_statement = {
    Sid    = "DBSchemaBucket"
    Effect = "Allow"
    Action = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:ListBucket",
      "s3:GetBucketTagging",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketWebsite",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketLogging",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:PutBucketTagging"
    ]
    Resource = "arn:aws:s3:::capstone-db-schema-bucket-249899229305-*"
  }

  # ===========================
  # SSM Parameter Store
  # ===========================
  github_actions_ssm_statement = {
    Sid    = "ReadAmazonLinuxParameter"
    Effect = "Allow"
    Action = [
      "ssm:GetParameter"
    ]
    Resource = "arn:aws:ssm:ap-southeast-1::parameter/aws/service/ami-amazon-linux-latest/*"
  }

  # ======================================
  # Terraform infrastructure state bucket
  # ======================================
  github_actions_terraform_state_bucket_statement = {
    Sid    = "TerraformStateBucket"
    Effect = "Allow"
    Action = [
      "s3:ListBucket"
    ]
    Resource = "arn:aws:s3:::capstone-terraform-state-249899229305-ap-southeast-1-an"
  }

  github_actions_terraform_state_obj_statement = {
    Sid    = "TerraformStateObject"
    Effect = "Allow"
    Action = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    Resource = [
      "arn:aws:s3:::capstone-terraform-state-249899229305-ap-southeast-1-an/infras/terraform.tfstate",
      "arn:aws:s3:::capstone-terraform-state-249899229305-ap-southeast-1-an/secrets/terraform.tfstate"
    ]
  }

  github_actions_terraform_state_lock_statement = {
    Sid    = "TerraformStateLock"
    Effect = "Allow"
    Action = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    Resource = [
      "arn:aws:s3:::capstone-terraform-state-249899229305-ap-southeast-1-an/infras/terraform.tfstate.tflock",
      "arn:aws:s3:::capstone-terraform-state-249899229305-ap-southeast-1-an/secrets/terraform.tfstate.tflock"
    ]
  }

  # ============
  # Route53
  # ============
  github_actions_route53_statement = {
    Sid    = "Route53"
    Effect = "Allow"
    Action = [
      "route53:CreateHostedZone"
    ]
    Resource = "*"
  }

  # =================================
  # Lambda deployment hook function
  # =================================
  github_actions_lambda_hook_statement = {
    Sid    = "LambdaDeploymentHook"
    Effect = "Allow"
    Action = [
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:ListVersionsByFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:DeleteFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration"
    ]
    Resource = [
      "arn:aws:lambda:ap-southeast-1:249899229305:function:driver-blue-green-hook-function",
      "arn:aws:lambda:us-east-1:249899229305:function:cognito-jwt-edge-auth-function"
    ]
  }

  # =================================
  # Lambda Edge Publish
  # =================================
  github_actions_lambda_egde_statement = {
    Sid    = "AllowGetCognitoJwtEdgeAuthFunction"
    Effect = "Allow"
    Actions = [
      "lambda:GetFunction"
    ]
    Resources = "arn:aws:lambda:us-east-1:249899229305:function:cognito-jwt-edge-auth-function:*"
  }

}

resource "aws_iam_policy" "github_actions_capstone_operation_policy" {
  name        = "github-actions-capstone-operation-policy"
  description = "CloudWatch logs, terraform state / db schema bucket, ssm parameter, route53, lambda hook function policies management"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_cloudwatch_logs_statement,
      local.github_actions_cloudwatch_describe_statement,
      local.github_actions_db_schema_bucket_statement,
      local.github_actions_ssm_statement,
      local.github_actions_terraform_state_bucket_statement,
      local.github_actions_terraform_state_obj_statement,
      local.github_actions_terraform_state_lock_statement,
      local.github_actions_route53_statement,
      local.github_actions_lambda_hook_statement,
      local.github_actions_lambda_egde_statement
    ]
  })
}

