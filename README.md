# 🌉 Oficina Mecânica Infra API Gateway

Infraestrutura da futura entrada pública única da Oficina Mecânica no Tech Challenge FIAP — Fase 3.

---

## 🎯 Objetivo

Este repositório será responsável por expor a solução por uma HTTP API, encaminhando `POST /auth/documento` para a Auth Lambda e `ANY /api/{proxy+}` para a API privada.

---

## 📌 Responsabilidades

Pertencem a esta esteira: HTTP API, stage `$default`, rotas, integrações, VPC Link, Security Group do VPC Link, regra VPC Link → NLB, Lambda permission, access logs e contratos SSM próprios.

Não pertencem a esta esteira: VPC/subnets, NLB/Target Group/listener, EKS, Service Kubernetes, Auth Lambda, RDS, secrets/JWT e workload da API.

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

`/api/health` será atendido pela rota proxy `ANY /api/{proxy+}`.

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

Contratos planejados/esperados: VPC (`/oficina-mecanica/development/status/vpc`, `vpc_id`, `private_subnet_ids`), Kubernetes (`status/kubernetes`, `internal_nlb_security_group_id`, `internal_nlb_listener_arn`) e Auth Lambda (`status/auth-lambda`, `function_arn`, `function_name`).

O Gateway publicará, somente após Terraform e deploy: `/oficina-mecanica/development/api-gateway/api-endpoint` e `/oficina-mecanica/development/status/api-gateway`.

---

## 📁 Estrutura do repositório

Hoje existem `README.md` e `.github/workflows/ci.yml`. A estrutura `infra/terraform/environments/dev` é prevista para a próxima rodada.

---

## 🌿 Git Flow e governança

```text
branch de trabalho -> develop -> release -> main
```

Branches protegidas: `develop`, `release`, `release/*` e `main`. Os rulesets ativos são `Aprovação de PR` e `Proteção Git Flow`; bypass por PR existe apenas no primeiro. Checks obrigatórios: `🔀 01 · Validar fluxo de branches` e `🚦 03 · Quality gate`.

---

## 🧪 CI

O CI atual possui detecção de escopo, validação Git Flow, validação Terraform condicional e Quality Gate. No bootstrap, a validação pesada pode ser pulada enquanto Terraform não existir; após sua inclusão, `fmt`, `init` e `validate` serão exigidos para mudanças deployáveis.

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

```text
Apply: VPC -> Kubernetes -> RDS -> API/NodePort -> Auth Lambda -> API Gateway
Destroy: API Gateway -> API workload -> Auth Lambda -> RDS -> Kubernetes -> VPC
```

---

## 📍 Status atual

| Item | Estado |
| --- | --- |
| Repositório, Git Flow, rulesets e CI | ✅ |
| README | Este PR |
| Terraform, CD Development, AWS Deploy e deploy real | ⏳ |
| E2E/cutover | ⏳ |

## 🗺️ Próximos passos

Terraform base, auditoria e merge, CD Development/AWS Deploy, `terraform-action.env`, Environment/secrets/variables, deploy real, validações E2E F3-012 e, somente depois, remoção da exposição pública legada.
