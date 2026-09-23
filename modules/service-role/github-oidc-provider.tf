resource "aws_iam_openid_connect_provider" "github-actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
}

// References to current ecs task role provisioned by capstone-infrastructure module
# data "aws_iam_role" "capstone-ecs-task-role" {
#   name = "capstone-ecs-task-role"
# }

// References to current ecs task execution role provisioned by capstone-infrastructure module
# data "aws_iam_role" "capstone-ecs-task-execution-role" {
#   name = "capstone-ecs-task-execution-role"
# }


// Rerun this when OIDC provider was NOT created by terraform
/*import {
  to = aws_iam_openid_connect_provider.github-actions
  id = "arn:aws:iam::249899229305:oidc-provider/token.actions.githubusercontent.com"
}*/


