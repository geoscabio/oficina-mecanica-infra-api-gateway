resource "aws_apigatewayv2_api" "gateway" {
  name             = "oficina-mecanica-api-gateway-dev"
  protocol_type    = "HTTP"
  fail_on_warnings = true

  body = templatefile("${path.module}/openapi/api-gateway.yaml.tftpl", {
    auth_lambda_function_arn  = data.aws_ssm_parameter.auth_lambda_function_arn.value
    aws_region                = var.aws_region
    internal_nlb_listener_arn = data.aws_ssm_parameter.internal_nlb_listener_arn.value
    vpc_link_id               = aws_apigatewayv2_vpc_link.gateway.id
  })
}

resource "aws_lambda_permission" "gateway_auth" {
  statement_id  = "AllowApiGatewayInvokeAuthDocumento"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_ssm_parameter.auth_lambda_function_name.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/POST/auth/documento"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    format = jsonencode({
      request_id                = "$context.requestId"
      route_key                 = "$context.routeKey"
      status                    = "$context.status"
      response_latency          = "$context.responseLatency"
      integration_status        = "$context.integration.status"
      integration_error_message = "$context.integrationErrorMessage"
      source_ip                 = "$context.identity.sourceIp"
      user_agent                = "$context.identity.userAgent"
    })
  }

  tags = local.observability_tags
}
