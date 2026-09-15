output "api_gateway_id" {
  description = "ID of the API Gateway HTTP API."
  value       = aws_apigatewayv2_api.gateway.id
}

output "api_gateway_endpoint" {
  description = "Public endpoint of the API Gateway HTTP API."
  value       = aws_apigatewayv2_api.gateway.api_endpoint
}

output "vpc_link_id" {
  description = "ID of the API Gateway VPC Link."
  value       = aws_apigatewayv2_vpc_link.gateway.id
}
