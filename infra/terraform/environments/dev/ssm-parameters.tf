resource "aws_ssm_parameter" "endpoint" {
  name  = "/oficina-mecanica/development/api-gateway/api-endpoint"
  type  = "String"
  value = aws_apigatewayv2_api.gateway.api_endpoint
}
resource "aws_ssm_parameter" "status" {
  name       = "/oficina-mecanica/development/status/api-gateway"
  type       = "String"
  value      = "ready"
  depends_on = [aws_apigatewayv2_stage.default]
}
