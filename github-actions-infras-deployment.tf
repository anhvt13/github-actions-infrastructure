// Configuring an IAM role for trusted Github capstone infrastructure repo
resource "aws_iam_role" "github-actions-infrastructure-deployment-role" {
  name = "github-actions-infrastructure-deployment-role"
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
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:ref:refs/heads/main",
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:environment:prod",
              "repo:anhvt13@42229955/capstone-infrastructure@1375700110:pull_request"
            ]
          }
        }
      }
    ]
  })
}

// Explicit Least privilege policies for deploy project's infrastructure by terraform
resource "aws_iam_role_policy" "github-actions-capstone-infrastructure-policy" {
  name = "github-actions-capstone-infrastructure-policy"
  role = aws_iam_role.github-actions-infrastructure-deployment-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # ============================================================
      # EC2 / VPC / Networking
      # ============================================================
      {
        Sid    = "Ec2Networking"
        Effect = "Allow"
        Action = [
          "ec2:AllocateAddress",
          "ec2:AssociateAddress",
          "ec2:AttachInternetGateway",
          "ec2:AssociateRouteTable",

          "ec2:CreateEgressOnlyInternetGateway",
          "ec2:CreateInternetGateway",
          "ec2:CreateNatGateway",
          "ec2:CreateNetworkAcl",
          "ec2:CreateNetworkAclEntry",
          "ec2:CreateRoute",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateTags",
          "ec2:CreateVpc",
          "ec2:CreateVpcEndpoint",

          "ec2:DeleteEgressOnlyInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteNatGateway",
          "ec2:DeleteNetworkAcl",
          "ec2:DeleteNetworkAclEntry",
          "ec2:DeleteRoute",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DeleteVpcEndpoints",

          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeEgressOnlyInternetGateways",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeNatGateways",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribePrefixLists",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeTags",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ec2:DescribeAddressesAttribute",
          "ec2:DisassociateAddress",

          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:ModifySubnetAttribute",
          "ec2:ModifyVpcAttribute",
          "ec2:ModifyVpcEndpoint",

          "ec2:ReleaseAddress",

          "ec2:ReplaceNetworkAclAssociation",
          "ec2:ReplaceNetworkAclEntry",
          "ec2:ReplaceRoute",

          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",

          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress"

        ]
        Resource = "*"
      },

      # ============================================================
      # EC2 instance / Bastion
      # ============================================================
      {
        Sid    = "Ec2Instance"
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StopInstances",
          "ec2:StartInstances",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      },

      # ============================================================
      # Manage Roles
      # ============================================================
      {
        Sid    = "ManageCapstoneRoles"
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
          "iam:UntagRole"
        ]
        Resource = [
          "arn:aws:iam::249899229305:role/capstone-bastion-ssm-instant-role",
          "arn:aws:iam::249899229305:role/capstone-ecs-task-role",
          "arn:aws:iam::249899229305:role/capstone-ecs-task-execution-role"
        ]
      },

      # ============================================================
      # Manage Policies
      # ============================================================
      {
        Sid    = "ManageCapstonePolicies"
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
          "arn:aws:iam::249899229305:policy/capstone-ecs-*"
        ]
      },

      # ============================================================
      # IAM Pass-Role
      # ============================================================
      {
        Sid    = "PassOnlyCapstoneRoles"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          "arn:aws:iam::249899229305:role/capstone-bastion-ssm-role",
          "arn:aws:iam::249899229305:role/capstone-ecs-task-role",
          "arn:aws:iam::249899229305:role/capstone-ecs-task-execution-role"
        ]
      },

      # ============================================================
      # ECS
      # ============================================================
      {
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
      },

      # ============================================================
      # AWS Cloud Map / ECS Service Connect namespace
      # ============================================================
      {
        Sid    = "ServiceDiscovery"
        Effect = "Allow"
        Action = [
          "servicediscovery:CreatePrivateDnsNamespace",
          "servicediscovery:DeleteNamespace",
          "servicediscovery:GetNamespace",
          "servicediscovery:GetOperation",
          "servicediscovery:ListNamespaces",
          "servicediscovery:TagResource",
          "servicediscovery:UntagResource"
        ]
        Resource = "*"
      },

      # ============================================================
      # Application Load Balancer
      # ============================================================
      {
        Sid    = "ElasticLoadBalancing"
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "elasticache:AddTagsToResource",

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

        ]
        Resource = "*"
      },

      # ============================================================
      # Aurora PostgreSQL
      # ============================================================
      {
        Sid    = "RdsAurora"
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
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      },

      # ============================================================
      # ElastiCache Serverless Valkey
      # ============================================================
      {
        Sid    = "ElastiCache"
        Effect = "Allow"
        Action = [
          "elasticache:CreateServerlessCache",
          "elasticache:DeleteServerlessCache",
          "elasticache:DescribeServerlessCaches",
          "elasticache:ModifyServerlessCache",
          "elasticache:TagResource",
          "elasticache:UntagResource"
        ]
        Resource = "*"
      },

      # ============================================================
      # Secrets Manager
      # ============================================================
      {
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
          "arn:aws:secretsmanager:ap-southeast-1:249899229305:secret:capstone/bff/oauth2-*"
        ]
      },

      # ============================================================
      # CloudWatch Logs
      # ============================================================
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy",
          "logs:DeleteRetentionPolicy",
          "logs:TagResource",
          "logs:UntagResource",
          "logs:ListTagsForResource",
          "logs:DescribeLogGroups"
        ]
        Resource = [
          "arn:aws:logs:ap-southeast-1:249899229305:log-group::log-stream"
        ]
      },

      # ============================================================
      # S3 - schema bucket
      # ============================================================
      {
        Sid    = "S3SchemaBucket"
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
          "s3:GetBucketTagging"
        ]
        Resource = "arn:aws:s3:::capstone-db-schema-bucket-249899229305-*"
      },

      # ============================================================
      # SSM Parameter Store
      # data.aws_ssm_parameter.al2023_arm64
      # ============================================================
      {
        Sid    = "ReadAmazonLinuxParameter"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter"
        ]
        Resource = "arn:aws:ssm:ap-southeast-1::parameter/aws/service/ami-amazon-linux-latest/*"
      }
    ]
  })
}


