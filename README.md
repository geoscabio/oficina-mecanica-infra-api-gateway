# Oficina Mecânica — Infraestrutura API Gateway

Entrada HTTP privada da solução Oficina Mecânica. A visão de produto e dos
repositórios está no [README da API](https://github.com/geoscabio/oficina-mecanica-api#readme).

## Responsabilidade e arquitetura

Este repositório provisiona o API Gateway HTTP API, VPC Link, integrações e logs
de acesso. A arquitetura final é:

```text
Internet -> API Gateway HTTP API
POST /auth/documento -> Auth Lambda -> RDS
ANY /api/{proxy+} -> VPC Link -> NLB interno -> target group -> EKS NodePort -> API Pods :8080
```

Não há LoadBalancer público no Service Kubernetes. As rotas de referência são
`GET /api/health`, `POST /auth/documento` e
`GET /api/v1/clientes/me/ordens-servico`.

## Repositórios da solução

| Repositório | Responsabilidade |
|---|---|
| [API](https://github.com/geoscabio/oficina-mecanica-api) | Aplicação .NET e documentação principal. |
| [Auth Lambda](https://github.com/geoscabio/oficina-mecanica-auth-lambda) | Autenticação por documento e JWT. |
| [VPC](https://github.com/geoscabio/oficina-mecanica-infra-vpc) | Rede base. |
| [Kubernetes](https://github.com/geoscabio/oficina-mecanica-infra-kubernetes) | EKS, NLB interno e NodePort. |
| [RDS](https://github.com/geoscabio/oficina-mecanica-infra-rds) | SQL Server privado. |
| [API Gateway](https://github.com/geoscabio/oficina-mecanica-infra-api-gateway) | Gateway HTTP, VPC Link e integração. |

## Tecnologias, pré-requisitos e configuração

Terraform, API Gateway v2 HTTP API, VPC Link, CloudWatch Logs, SSM Parameter
Store e GitHub Actions. VPC, Kubernetes e Auth Lambda precisam estar aplicados e
publicar seus contratos antes do deploy deste repositório.

| Nome | Tipo e escopo | Obrigatório | Finalidade |
|---|---|---:|---|
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | GitHub Environment Secrets (`development`) | Sim | Credenciais AWS. |
| `AWS_SESSION_TOKEN` | GitHub Environment Secret (`development`) | Quando temporário | Sessão AWS. |
| `AWS_REGION` | GitHub Variable | Sim | Região AWS. |
| `AUTO_PR_ENABLED`, `RELEASE_BRANCH` | GitHub Variables | Não | Promoção. |

Consome `/oficina-mecanica/development/status/vpc`, `/vpc/vpc_id`,
`/vpc/private_subnet_ids`, `/status/kubernetes`,
`/kubernetes/internal_nlb_security_group_id`,
`/kubernetes/internal_nlb_listener_arn`, `/status/auth-lambda`,
`/auth-lambda/function_arn` e `/auth-lambda/function_name`. Publica
`/oficina-mecanica/development/api-gateway/api-endpoint` e
`/oficina-mecanica/development/status/api-gateway`.

## CI/CD, deploy e observabilidade

O workflow `aws-deploy.yml` executa o fluxo existente de plan/apply/destroy. No
diretório `infra/terraform/environments/dev`, execute:

```powershell
terraform fmt -check
terraform validate
terraform plan
```

Os access logs são enviados para o CloudWatch Log Group
`/aws/apigateway/oficina-mecanica-api-gateway-dev`, com retenção de 14 dias. O
formato inclui request id, route key, status, latência de resposta, status/erro de
integração, IP de origem e user agent; métricas nativas do API Gateway completam
a observabilidade. A integração Datadog é etapa posterior e não está declarada
como ingestão ativa neste repositório.

Valide `git diff --check` e os checks do workflow antes de promover.

Documentação: [API principal](https://github.com/geoscabio/oficina-mecanica-api#readme),
[API Gateway HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
e [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/).
