data "aws_ssm_parameter" "vpc_id" { name = "/oficina-mecanica/development/vpc/vpc_id" }
data "aws_ssm_parameter" "private_subnet_ids" { name = "/oficina-mecanica/development/vpc/private_subnet_ids" }
data "aws_ssm_parameter" "nlb_sg" { name = "/oficina-mecanica/development/kubernetes/internal_nlb_security_group_id" }
data "aws_ssm_parameter" "listener" { name = "/oficina-mecanica/development/kubernetes/internal_nlb_listener_arn" }
data "aws_ssm_parameter" "lambda_arn" { name = "/oficina-mecanica/development/auth-lambda/function_arn" }
data "aws_ssm_parameter" "lambda_name" { name = "/oficina-mecanica/development/auth-lambda/function_name" }
