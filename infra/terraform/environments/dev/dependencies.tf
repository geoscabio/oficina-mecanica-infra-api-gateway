data "aws_ssm_parameter" "vpc_status" {
  name = var.vpc_status_parameter_name
}

data "aws_ssm_parameter" "vpc_id" {
  name = "${var.vpc_ssm_prefix}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "${var.vpc_ssm_prefix}/private_subnet_ids"
}

data "aws_ssm_parameter" "kubernetes_status" {
  name = var.kubernetes_status_parameter_name
}

data "aws_ssm_parameter" "internal_nlb_security_group_id" {
  name = "${var.kubernetes_ssm_prefix}/internal_nlb_security_group_id"
}

data "aws_ssm_parameter" "internal_nlb_listener_arn" {
  name = "${var.kubernetes_ssm_prefix}/internal_nlb_listener_arn"
}

data "aws_ssm_parameter" "auth_lambda_status" {
  name = var.auth_lambda_status_parameter_name
}

data "aws_ssm_parameter" "auth_lambda_function_arn" {
  name = "${var.auth_lambda_ssm_prefix}/function_arn"
}

data "aws_ssm_parameter" "auth_lambda_function_name" {
  name = "${var.auth_lambda_ssm_prefix}/function_name"
}
