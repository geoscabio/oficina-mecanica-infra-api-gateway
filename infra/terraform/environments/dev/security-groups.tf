resource "aws_security_group" "vpc_link" {
  name   = "oficina-mecanica-api-vpc-link-sg-dev"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}
resource "aws_vpc_security_group_egress_rule" "to_nlb" {
  security_group_id            = aws_security_group.vpc_link.id
  referenced_security_group_id = data.aws_ssm_parameter.nlb_sg.value
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}
resource "aws_vpc_security_group_ingress_rule" "nlb_from_link" {
  security_group_id            = data.aws_ssm_parameter.nlb_sg.value
  referenced_security_group_id = aws_security_group.vpc_link.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}
