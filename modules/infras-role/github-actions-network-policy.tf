locals {
  #=================================
  # EC2 / VPC / Networking
  # ================================
  github_actions_ec2_networking_statement = {
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
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DisassociateRouteTable",
      "ec2:DetachInternetGateway",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:ModifySecurityGroupRules",
      "ec2:DeleteNetworkInterface"
    ]
    Resource = "*"
  }

  # =============================
  # EC2 instance / Bastion
  # =============================
  github_actions_ec2_instance_statement = {
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
  }


  # =============================
  # SSM Parameter
  # =============================
  github_actions_read_amazon_linux_parameter_statement = {
    Sid      = "ReadAmazonLinuxParameter"
    Effect   = "Allow"
    Action   = ["ssm:GetParameter"]
    Resource = "arn:aws:ssm:ap-southeast-1::parameter/aws/service/ami-amazon-linux-latest/*"
  }
}

resource "aws_iam_policy" "github_actions_capstone_network_policy" {
  name        = "github-actions-capstone-network-policy"
  description = "EC2 networking, instance operations, and Amazon Linux parameter access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      local.github_actions_ec2_networking_statement,
      local.github_actions_ec2_instance_statement,
      local.github_actions_read_amazon_linux_parameter_statement
    ]
  })
}
