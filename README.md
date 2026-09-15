# Oficina Mecânica Infra API Gateway

Infraestrutura do API Gateway da Oficina Mecânica para o Tech Challenge FIAP — Fase 3.

## Objetivo

Centralizar a futura entrada pública da solução, encaminhando autenticação para a Auth Lambda e as rotas da API para o NLB interno via VPC Link.

## Arquitetura e rotas planejadas

`Internet -> API Gateway -> VPC Link -> NLB interno -> EKS/API`.

- `POST /auth/documento` -> Auth Lambda
- `ANY /api/{proxy+}` -> VPC Link -> NLB interno

## Stack e dependências

Terraform e AWS API Gateway v2. Depende da VPC, do Kubernetes/NLB interno e da Auth Lambda.

## Estrutura e fluxo

O Terraform ficará em `infra/terraform/environments/dev`. O Git Flow usa `branch de trabalho -> develop -> release -> main`. O CI valida origem do PR, escopo e Terraform quando a infraestrutura existir.

## Estado atual e validação local

O repositório está em setup; a base Terraform está em PR separado e ainda não foi mergeada nem implantada. CD e deploy serão adicionados em rodada posterior.

Quando houver Terraform, validar com `terraform fmt -check -recursive infra/terraform`, `terraform -chdir=infra/terraform/environments/dev init -backend=false -input=false` e `terraform -chdir=infra/terraform/environments/dev validate`.
