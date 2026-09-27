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

  capstone_ecs_task_execution_role_arn = var.capstone_ecs_task_execution_role_arn
  capstone_ecs_task_role_arn           = var.capstone_ecs_task_role_arn
}
