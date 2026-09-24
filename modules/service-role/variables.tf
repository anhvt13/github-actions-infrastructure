// References to ecs task role provisioned by capstone-infrastructure module
data "aws_iam_role" "capstone-ecs-task-role" {
  name = "capstone-ecs-task-role"
}

// References to ecs task execution role provisioned by capstone-infrastructure module
data "aws_iam_role" "capstone-ecs-task-execution-role" {
  name = "capstone-ecs-task-execution-role"
}