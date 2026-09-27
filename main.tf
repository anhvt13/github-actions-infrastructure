# =========================
# Infrastructure Role module
# ==========================
module "infras-role" {
  source = "./modules/infras-role"
}

# =========================
# ECS Service Role module
# ==========================
module "service-role" {
  source = "./modules/service-role"

  capstone_ecs_task_execution_role_arn = data.aws_iam_role.capstone-ecs-task-execution-role.arn
  capstone_ecs_task_role_arn           = data.aws_iam_role.capstone-ecs-task-role.arn
}
