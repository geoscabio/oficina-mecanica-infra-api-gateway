# 🌉 Oficina Mecânica Infra API Gateway

Infraestrutura da futura entrada pública única da Oficina Mecânica no Tech Challenge FIAP — Fase 3.

---

## 🎯 Objetivo

Este repositório será responsável por expor a solução por uma HTTP API, encaminhando `POST /auth/documento` para a Auth Lambda e `ANY /api/{proxy+}` para a API privada.

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

---

## 🧰 Tecnologias

| Tecnologia | Papel planejado |
| --- | --- |
| Terraform | Infraestrutura declarativa |
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

Estado atual:

```text
.
├── .github/
│   └── workflows/
│       └── ci.yml
└── README.md
```

Estrutura planejada, ainda inexistente:

```text
infra/terraform/environments/dev/
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
| `🌐 02 · Validar Terraform do API Gateway` | Executará fmt/init/validate quando Terraform existir |
| `🚦 03 · Quality gate` | Consolida os resultados |

No bootstrap, a validação pesada pode ser pulada; após a inclusão do Terraform, ela será exigida para mudanças deployáveis.

---

## 🚀 Validação local futura

Após a inclusão do Terraform:

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
| README | 🚧 |
| Terraform | ⏳ |
| CD Development | ⏳ |
| AWS Deploy | ⏳ |
| Deploy real | ⏳ |
| E2E F3-012 | ⏳ |
| Cutover | ⏳ |

## 🗺️ Próximos passos

1. Terraform base
2. Auditoria
3. Merge
4. CD Development / AWS Deploy
5. `terraform-action.env`
6. GitHub Environment/secrets/variables
7. Deploy real
8. E2E F3-012
9. Remoção da exposição pública legada somente após aceite
