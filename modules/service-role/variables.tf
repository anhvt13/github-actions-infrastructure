variable "capstone_ecs_task_role_arn" {
  description = "The ARN of ECS task role"
  type        = string
  default     = "arn:aws:iam::249899229305:role/capstone-ecs-task-role"
}

variable "capstone_ecs_task_execution_role_arn" {
  description = "The ARN of ECS task execution role"
  type        = string
  default     = "arn:aws:iam::249899229305:role/capstone-ecs-task-execution-role"
}
