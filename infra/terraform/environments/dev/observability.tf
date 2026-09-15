resource "aws_cloudwatch_log_group" "gateway" {
  name              = "/aws/apigateway/oficina-mecanica-api-gateway-dev"
  retention_in_days = 14
}
