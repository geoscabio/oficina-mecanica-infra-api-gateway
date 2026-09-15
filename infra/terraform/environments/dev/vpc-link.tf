resource "aws_apigatewayv2_vpc_link" "gateway" {
  name               = "oficina-mecanica-api-vpc-link-dev"
  subnet_ids         = local.private_subnet_ids
  security_group_ids = [aws_security_group.vpc_link.id]
}
