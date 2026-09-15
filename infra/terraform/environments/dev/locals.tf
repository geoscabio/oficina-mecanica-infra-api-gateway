locals {
  project_name = "OficinaMecanica"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "oficina-mecanica-infra-api-gateway"
  }

  observability_tags = {
    env     = var.environment
    service = "oficina-mecanica-api-gateway"
  }

  vpc_id = data.aws_ssm_parameter.vpc_id.value

  private_subnet_ids = split(
    ",",
    data.aws_ssm_parameter.private_subnet_ids.value
  )
}
