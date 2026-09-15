resource "aws_apigatewayv2_vpc_link" "gateway" {
  name               = "oficina-mecanica-api-gateway-vpc-link-dev"
  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_link.id]

  tags = merge(local.common_tags, {
    Name         = "oficina-mecanica-api-gateway-vpc-link-dev"
    ResourceType = "ApiGatewayVpcLink"
  })
}
