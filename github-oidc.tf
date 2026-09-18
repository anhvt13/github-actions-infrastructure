resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
}

import {
  to = aws_iam_openid_connect_provider.github_actions
  id = "arn:aws:iam::249899229305:oidc-provider/token.actions.githubusercontent.com"
}


