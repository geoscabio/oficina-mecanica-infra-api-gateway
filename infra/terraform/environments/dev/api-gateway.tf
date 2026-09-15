resource "aws_apigatewayv2_api" "gateway" {
  name          = "oficina-mecanica-api-gateway-dev"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "auth_lambda" {
  api_id                 = aws_apigatewayv2_api.gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_ssm_parameter.auth_lambda_function_arn.value
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "auth_documento" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /auth/documento"
  target    = "integrations/${aws_apigatewayv2_integration.auth_lambda.id}"
}

resource "aws_lambda_permission" "gateway_auth" {
  statement_id  = "AllowApiGatewayInvokeAuthDocumento"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_ssm_parameter.auth_lambda_function_name.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/POST/auth/documento"
}

resource "aws_apigatewayv2_integration" "private_api" {
  api_id             = aws_apigatewayv2_api.gateway.id
  integration_type   = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.gateway.id
  integration_method = "ANY"
  integration_uri    = data.aws_ssm_parameter.internal_nlb_listener_arn.value

  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

resource "aws_apigatewayv2_route" "private_api" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.private_api.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      protocol                = "$context.protocol"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}
