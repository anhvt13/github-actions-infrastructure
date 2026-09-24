// References to github action OIDC provider
data "aws_iam_openid_connect_provider" "github-actions" {
  name = "github-actions"
}