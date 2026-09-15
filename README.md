# Oficina Mecânica Infra API Gateway

Infraestrutura do API Gateway da Oficina Mecânica para o Tech Challenge FIAP — Fase 3.

## Objetivo

Centralizar a futura entrada pública da solução, encaminhando autenticação para a Auth Lambda e as rotas da API para o NLB interno via VPC Link.

## Responsabilidades

- Provisionar futuramente HTTP API, VPC Link, integrações, rotas e access logs.
- Consumir contratos da VPC, Kubernetes/NLB interno e Auth Lambda.
- Publicar exclusivamente os contratos SSM próprios do Gateway.

## Arquitetura e rotas planejadas

`Internet -> API Gateway -> VPC Link -> NLB interno -> EKS/API`.

- `POST /auth/documento` -> Auth Lambda
- `ANY /api/{proxy+}` -> VPC Link -> NLB interno

## Stack e dependências

Terraform e AWS API Gateway v2. Depende da VPC, do Kubernetes/NLB interno e da Auth Lambda.

Contratos consumidos: status e IDs da VPC; status, SG e listener do NLB interno; status, ARN e nome da Auth Lambda. Publicará `/oficina-mecanica/development/api-gateway/api-endpoint` e `/oficina-mecanica/development/status/api-gateway`.

## Estrutura e fluxo

O Terraform ficará em `infra/terraform/environments/dev`. O Git Flow usa `branch de trabalho -> develop -> release -> main`. O CI valida origem do PR, escopo e Terraform quando a infraestrutura existir.

Branches protegidas: `develop`, `release`, `release/*` e `main`. Os rulesets ativos são `Proteção Git Flow` e `Aprovação de PR`.

## CI

O CI atual contém detecção de escopo, `🔀 01 · Validar fluxo de branches`, validação Terraform condicional e `🚦 03 · Quality gate`.

## Estado atual e validação local

O repositório está em setup; a base Terraform está em PR separado e ainda não foi mergeada nem implantada. CD e deploy serão adicionados em rodada posterior.

CD Development, AWS Deploy, `terraform-action.env`, Environment/secrets e deploy real ainda não existem. A ordem da Fase 3 é VPC -> Kubernetes -> API -> API Gateway.

Quando houver Terraform, validar com `terraform fmt -check -recursive infra/terraform`, `terraform -chdir=infra/terraform/environments/dev init -backend=false -input=false` e `terraform -chdir=infra/terraform/environments/dev validate`.
