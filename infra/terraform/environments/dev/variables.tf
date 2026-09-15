variable "aws_region" {
  description = "AWS region where the API Gateway infrastructure will be provisioned."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Provisioned environment name."
  type        = string
  default     = "development"
}

variable "vpc_ssm_prefix" {
  description = "SSM prefix published by the VPC pipeline."
  type        = string
  default     = "/oficina-mecanica/development/vpc"
}

variable "vpc_status_parameter_name" {
  description = "SSM parameter that marks the VPC as ready."
  type        = string
  default     = "/oficina-mecanica/development/status/vpc"
}

variable "kubernetes_ssm_prefix" {
  description = "SSM prefix published by the Kubernetes pipeline."
  type        = string
  default     = "/oficina-mecanica/development/kubernetes"
}

variable "kubernetes_status_parameter_name" {
  description = "SSM parameter that marks Kubernetes as ready."
  type        = string
  default     = "/oficina-mecanica/development/status/kubernetes"
}

variable "auth_lambda_ssm_prefix" {
  description = "SSM prefix published by the Auth Lambda pipeline."
  type        = string
  default     = "/oficina-mecanica/development/auth-lambda"
}

variable "auth_lambda_status_parameter_name" {
  description = "SSM parameter that marks the Auth Lambda as ready."
  type        = string
  default     = "/oficina-mecanica/development/status/auth-lambda"
}

variable "api_gateway_ssm_prefix" {
  description = "SSM prefix published by this API Gateway pipeline."
  type        = string
  default     = "/oficina-mecanica/development/api-gateway"
}

variable "api_gateway_status_parameter_name" {
  description = "SSM parameter that marks the API Gateway as ready."
  type        = string
  default     = "/oficina-mecanica/development/status/api-gateway"
}
