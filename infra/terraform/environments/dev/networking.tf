resource "aws_security_group" "vpc_link" {
  name        = "oficina-mecanica-api-gateway-vpc-link-sg-dev"
  description = "Security group used by the API Gateway VPC Link to reach the internal API NLB."
  vpc_id      = local.vpc_id

  tags = merge(local.common_tags, {
    Name         = "oficina-mecanica-api-gateway-vpc-link-sg-dev"
    ResourceType = "SecurityGroup"
  })
}

resource "aws_vpc_security_group_egress_rule" "vpc_link_to_nlb" {
  security_group_id            = aws_security_group.vpc_link.id
  referenced_security_group_id = data.aws_ssm_parameter.internal_nlb_security_group_id.value
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  description                  = "Allow the API Gateway VPC Link to reach the internal API NLB listener."
}

resource "aws_vpc_security_group_ingress_rule" "nlb_from_vpc_link" {
  security_group_id            = data.aws_ssm_parameter.internal_nlb_security_group_id.value
  referenced_security_group_id = aws_security_group.vpc_link.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  description                  = "Allow the API Gateway VPC Link to reach the internal API NLB listener."
}

resource "aws_apigatewayv2_vpc_link" "gateway" {
  name               = "oficina-mecanica-api-gateway-vpc-link-dev"
  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_link.id]

  tags = merge(local.common_tags, {
    Name         = "oficina-mecanica-api-gateway-vpc-link-dev"
    ResourceType = "ApiGatewayVpcLink"
  })
}
