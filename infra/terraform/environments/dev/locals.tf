locals {
  tags               = { Project = "OficinaMecanica", Environment = "Development", ManagedBy = "Terraform", Component = "ApiGateway" }
  private_subnet_ids = jsondecode(data.aws_ssm_parameter.private_subnet_ids.value)
}
