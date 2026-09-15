# 🌉 Oficina Mecânica Infra API Gateway

Infraestrutura da entrada pública única da Oficina Mecânica no Tech Challenge FIAP — Fase 3.

---

## 🎯 Objetivo

Este repositório é responsável por definir a HTTP API que encaminha `POST /auth/documento` para a Auth Lambda e `ANY /api/{proxy+}` para a API privada.

O contrato OpenAPI do edge é a fonte da verdade das rotas e integrações do Gateway. O Terraform continua responsável pelo recurso do API Gateway, stage, VPC Link, segurança, observabilidade, permissões, contratos SSM e outputs.

---

## 📌 Responsabilidades

| Este repositório possui | Consome | Não pertence a este repositório |
| --- | --- | --- |
| HTTP API, stage `$default`, rotas, integrações, VPC Link, SG do VPC Link, regra VPC Link → NLB, Lambda permission, access logs e SSM próprio | Contratos da VPC, Kubernetes/NLB interno e Auth Lambda | VPC/subnets, NLB/Target Group/listener, EKS, Service Kubernetes, Auth Lambda, RDS, secrets/JWT e workload da API |

---

## 🏗️ Arquitetura

```text
Internet
   |
   v
API Gateway HTTP API
   +-- POST /auth/documento -> Auth Lambda -> RDS
   +-- ANY /api/{proxy+} -> VPC Link -> NLB interno -> EKS/API
```

| Rota | Destino planejado |
| --- | --- |
| `POST /auth/documento` | Auth Lambda |
| `ANY /api/{proxy+}` | VPC Link → NLB interno → EKS/API |
| `/api/health` | Atendida pela rota proxy |

O backend permanecerá privado; o Gateway será a entrada pública única somente após o cutover F3-012.

### OpenAPI do edge × Swagger da aplicação

O arquivo `openapi/api-gateway.yaml.tftpl` descreve somente o contrato público do edge: a autenticação por documento e o proxy privado sob `/api/*`. Ele não substitui nem duplica o Swagger completo da aplicação .NET, que continua sendo dona das rotas internas `/api/...` e `/api/v1/...`.

As rotas e integrações do Gateway são importadas pelo atributo `aws_apigatewayv2_api.body`. Os demais recursos de infraestrutura continuam declarados diretamente em Terraform.

---

## 🧰 Tecnologias

| Tecnologia | Papel |
| --- | --- |
| Terraform | Infraestrutura declarativa |
| OpenAPI 3.0.1 | Contrato das rotas e integrações do edge |
| API Gateway v2 HTTP API | Entrada pública |
| VPC Link / NLB interno | Conectividade privada |
| Lambda / EKS | Destinos das rotas |
| SSM Parameter Store | Contratos entre esteiras |
| CloudWatch Logs | Access logs |
| GitHub Actions | Integração contínua |

---

## 🔗 Dependências e contratos SSM

| Contrato | Uso | Papel |
| --- | --- | --- |
| `/oficina-mecanica/development/status/vpc` | Estado da VPC | Consumido |
| `/oficina-mecanica/development/vpc/vpc_id` | VPC do VPC Link | Consumido |
| `/oficina-mecanica/development/vpc/private_subnet_ids` | Subnets privadas | Consumido |
| `/oficina-mecanica/development/status/kubernetes` | Estado Kubernetes | Consumido |
| `/oficina-mecanica/development/kubernetes/internal_nlb_security_group_id` | SG do NLB | Consumido |
| `/oficina-mecanica/development/kubernetes/internal_nlb_listener_arn` | Listener TCP/80 | Consumido |
| `/oficina-mecanica/development/status/auth-lambda` | Estado Auth Lambda | Consumido |
| `/oficina-mecanica/development/auth-lambda/function_arn` | Integração Lambda | Consumido |
| `/oficina-mecanica/development/auth-lambda/function_name` | Permissão Lambda | Consumido |
| `/oficina-mecanica/development/api-gateway/api-endpoint` | Endpoint público | Publicado após deploy |
| `/oficina-mecanica/development/status/api-gateway` | Estado do Gateway | Publicado após deploy |

---

## 📁 Estrutura do repositório

```text
.
├── .github/
│   └── workflows/
│       └── ci.yml
├── infra/
│   └── terraform/
│       └── environments/
│           └── dev/
│               ├── openapi/
│               │   └── api-gateway.yaml.tftpl
│               ├── api-gateway.tf
│               ├── networking.tf
│               ├── dependencies.tf
│               ├── observability.tf
│               ├── contracts.tf
│               ├── outputs.tf
│               ├── locals.tf
│               ├── variables.tf
│               ├── providers.tf
│               ├── versions.tf
│               └── .terraform.lock.hcl
└── README.md
```

---

## 🌿 Git Flow e governança

```text
branch de trabalho -> develop -> release -> main
```

```text
branch de trabalho -> PR develop -> PR release -> PR main
```

Branches protegidas: `develop`, `release`, `release/*` e `main`.

- `Proteção Git Flow`: exige PR, resolução de conversas e checks; bloqueia push direto, force push e deletion; não possui bypass.
- `Aprovação de PR`: exige revisão e permite bypass somente via PR para atores autorizados.

Checks obrigatórios: `🔀 01 · Validar fluxo de branches` e `🚦 03 · Quality gate`.

---

## 🧪 CI

| Job | Responsabilidade |
| --- | --- |
| `🔎 00 · Detectar escopo do PR` | Identifica mudanças relevantes |
| `🔀 01 · Validar fluxo de branches` | Confere origem e destino do PR |
| `🌐 02 · Validar Terraform do API Gateway` | Executa fmt/init/validate para mudanças relevantes |
| `🚦 03 · Quality gate` | Consolida os resultados |

Com o Terraform presente, a validação pesada é exigida para mudanças deployáveis.

---

## 🚀 Validação local

```text
terraform fmt -check -recursive infra/terraform
terraform -chdir=infra/terraform/environments/dev init -backend=false -input=false
terraform -chdir=infra/terraform/environments/dev validate
```

---

## 🧨 Ordem de operação

#### Apply

1. VPC
2. Kubernetes
3. RDS
4. API workload / NodePort
5. Auth Lambda
6. API Gateway

#### Destroy

1. API Gateway
2. API workload
3. Auth Lambda
4. RDS
5. Kubernetes
6. VPC

---

## 📍 Status atual

| Item | Estado |
| --- | --- |
| Repositório | ✅ |
| main/develop/release | ✅ |
| Rulesets | ✅ |
| CI | ✅ |
| README | ✅ |
| Terraform | ✅ |
| Contrato OpenAPI do edge | ✅ |
| CD Development | ⏳ |
| AWS Deploy | ⏳ |
| Deploy real | ⏳ |
| E2E F3-012 | ⏳ |
| Cutover | ⏳ |

## 🗺️ Próximos passos

1. Auditoria e merge da refatoração OpenAPI-first
2. Merge separado do CD Development / AWS Deploy pelo PR #5
3. `terraform-action.env`
4. GitHub Environment/secrets/variables
5. Deploy real
6. E2E F3-012
7. Remoção da exposição pública legada somente após aceite
