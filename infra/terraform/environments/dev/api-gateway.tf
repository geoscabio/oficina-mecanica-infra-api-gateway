resource "aws_apigatewayv2_api" "gateway" {
  name          = "oficina-mecanica-api-gateway-dev"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "private" {
  api_id                 = aws_apigatewayv2_api.gateway.id
  integration_type       = "HTTP_PROXY"
  integration_method     = "ANY"
  integration_uri        = data.aws_ssm_parameter.listener.value
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.gateway.id
  payload_format_version = "1.0"
  request_parameters     = { "overwrite:path" = "$request.path" }
}

resource "aws_apigatewayv2_integration" "auth" {
  api_id                 = aws_apigatewayv2_api.gateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_ssm_parameter.lambda_arn.value
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "private" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "ANY /api/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.private.id}"
}

resource "aws_apigatewayv2_route" "auth" {
  api_id    = aws_apigatewayv2_api.gateway.id
  route_key = "POST /auth/documento"
  target    = "integrations/${aws_apigatewayv2_integration.auth.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    format          = jsonencode({ requestId = "$context.requestId", routeKey = "$context.routeKey", status = "$context.status", responseLength = "$context.responseLength", integrationErrorMessage = "$context.integrationErrorMessage" })
  }
}

resource "aws_lambda_permission" "gateway_auth" {
  statement_id  = "AllowApiGatewayAuth"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_ssm_parameter.lambda_name.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.gateway.execution_arn}/*/auth/documento"
}
