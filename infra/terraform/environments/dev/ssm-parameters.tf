resource "aws_ssm_parameter" "api_endpoint" {
  name        = "${var.api_gateway_ssm_prefix}/api-endpoint"
  description = "Public endpoint of the Oficina Mecanica API Gateway."
  type        = "String"
  value       = aws_apigatewayv2_api.gateway.api_endpoint

  tags = local.common_tags
}

resource "aws_ssm_parameter" "status" {
  depends_on = [
    aws_apigatewayv2_api.gateway,
    aws_apigatewayv2_stage.default,
    aws_apigatewayv2_integration.auth_lambda,
    aws_apigatewayv2_route.auth_documento,
    aws_apigatewayv2_integration.private_api,
    aws_apigatewayv2_route.private_api,
    aws_apigatewayv2_vpc_link.gateway,
    aws_lambda_permission.gateway_auth,
    aws_security_group.vpc_link,
    aws_vpc_security_group_egress_rule.vpc_link_to_nlb,
    aws_vpc_security_group_ingress_rule.nlb_from_vpc_link,
    aws_cloudwatch_log_group.gateway,
    aws_ssm_parameter.api_endpoint,
  ]

  name        = var.api_gateway_status_parameter_name
  description = "Operational status of the API Gateway infrastructure."
  type        = "String"
  value       = "ready"

  tags = local.common_tags
}
