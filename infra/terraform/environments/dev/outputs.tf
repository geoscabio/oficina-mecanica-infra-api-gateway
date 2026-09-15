output "api_gateway_id" { value = aws_apigatewayv2_api.gateway.id }
output "api_gateway_endpoint" { value = aws_apigatewayv2_api.gateway.api_endpoint }
output "vpc_link_id" { value = aws_apigatewayv2_vpc_link.gateway.id }
