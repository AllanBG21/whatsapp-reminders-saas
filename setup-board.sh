#!/usr/bin/env bash
set -euo pipefail

# === Vars ===
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
OWNER=$(gh repo view --json owner --jq .owner.login)
TITLE="WhatsApp Reminders SaaS (MVP)"

echo "Repo: $REPO"
echo "Owner: $OWNER"
echo "Project title: $TITLE"

# === Project (idempotente) ===
gh project create --owner "$OWNER" --title "$TITLE" >/dev/null 2>&1 || true
PN=$(gh project list --owner "$OWNER" --format json | jq -r --arg t "$TITLE" '.projects[] | select(.title==$t) | .number')
[ -n "$PN" ] || { echo "❌ No pude obtener el número del Project"; exit 1; }
echo "Project number: $PN"

# === Milestones (Sprints) ===
S1="Sprint 1 — API Skeleton + Send Template"
S2="Sprint 2 — Webhook Verify + Ingesta"
S3="Sprint 3 — Scheduler (BullMQ) + Jobs"
S4="Sprint 4 — Persistencia (Postgres/Prisma)"
S5="Sprint 5 — Web mínima (Next.js)"
S6="Sprint 6 — Auth + Rate Limiting"
S7="Sprint 7 — Calidad, CI/CD y Deploy"

for M in "$S1" "$S2" "$S3" "$S4" "$S5" "$S6" "$S7"; do
  gh api repos/$REPO/milestones -f title="$M" >/dev/null 2>&1 || true
done
echo "✅ Milestones listos."

# === Labels mínimos (idempotentes) ===
declare -a LABELS=(
"area/api:#1f77b4:API scope"
"area/web:#2ca02c:Web scope"
"area/infra:#9467bd:Infra/DevOps"
"area/devex:#8c564b:Dev Experience"
"type/feat:#d62728:Feature"
"type/chore:#17becf:Chore/Infra"
"type/docs:#bcbd22:Docs"
"type/test:#7f7f7f:Tests"
"priority/P0:#000000:Blocker"
"priority/P1:#e377c2:High"
"status/ready:#9edae5:Ready"
"status/in-progress:#fbca04:In Progress"
"status/review:#f7b6d2:In Review"
"status/done:#2ca02c:Done"
)
for L in "${LABELS[@]}"; do
  NAME="${L%%:*}"; REST="${L#*:}"; COLOR="${REST%%:*}"; DESC="${REST#*:}"
  gh label create "$NAME" --color "${COLOR#\#}" --description "$DESC" >/dev/null 2>&1 || true
done
echo "✅ Labels listos."

# === Helper: crear issue y añadirlo al Project ===
add_issue () {
  local title="$1"; local body="$2"; local ms="$3"; shift 3
  local labels=( "$@" )
  local args=()
  for l in "${labels[@]}"; do args+=( -l "$l" ); done
  local num url
  num=$(gh issue create -t "$title" -b "$body" -m "$ms" "${args[@]}" --json number --jq .number)
  url="https://github.com/$REPO/issues/$num"
  gh project item-add "$PN" --owner "$OWNER" --url "$url" >/dev/null
  echo "• #$num  $title"
}

echo "👉 Creando issues por sprint…"

# === Sprint 1 ===
add_issue "feat(api): @nestjs/config + env validation" "Validación de env con class-validator/zod; error claro; logging." "$S1" area/api type/feat status/ready
add_issue "feat(api): WhatsappService.sendTemplate() (axios+timeouts)" "Enviar plantilla WhatsApp Cloud API; manejo de errores y timeouts." "$S1" area/api type/feat status/ready priority/P0
add_issue "feat(api): POST /v1/notifications/send" "DTO: to, template, lang, params[]; 200 con requestId." "$S1" area/api type/feat status/ready priority/P0
add_issue "chore(api): pino logger + interceptores" "pino-http; tiempos; mapping de excepciones." "$S1" area/api type/chore status/ready
add_issue "chore(root): scripts dev:api / start:api" "pnpm -C apps/api start:dev; README." "$S1" area/devex type/chore status/ready

# === Sprint 2 ===
add_issue "feat(api): GET /webhook/whatsapp (verify hub.challenge)" "Responder 200 con hub.challenge; documentar pasos." "$S2" area/api type/feat status/ready
add_issue "feat(api): POST /webhook/whatsapp → MessageLog" "Persistir JSON entrante; 200 OK." "$S2" area/api type/feat status/ready
add_issue "docs(infra): ngrok/cloudflared + config Meta" "Guía pública HTTPS; notas de seguridad." "$S2" area/infra type/docs status/ready

# === Sprint 3 ===
add_issue "feat(infra): Redis + BullMQ base" "Compose Redis; conexión desde API; healthcheck." "$S3" area/infra type/feat status/ready
add_issue "feat(api): job send-reminder (backoff 3)" "Leer Reminder; invocar WhatsappService; reintentos exponenciales." "$S3" area/api type/feat status/ready
add_issue "feat(api): POST /v1/reminders" "to, template, when, params[]; delay +2 min dispara envío." "$S3" area/api type/feat status/ready
add_issue "chore(api): cron fallback + limpieza de jobs" "Purgas semanales; métricas mínimas." "$S3" area/api type/chore status/ready

# === Sprint 4 ===
add_issue "feat(infra): Postgres + Redis (Compose)" "Volúmenes persistentes; healthchecks." "$S4" area/infra type/feat status/ready
add_issue "feat(api): Prisma schema (User, Contact, Template, Reminder, MessageLog)" "Migraciones; índices; enums." "$S4" area/api type/feat status/ready
add_issue "feat(api): repos/servicios Prisma + wiring" "IOC; servicios; pruebas básicas." "$S4" area/api type/feat status/ready
add_issue "chore(api): migraciones y seed" "pnpm -C apps/api prisma migrate dev; seed demo." "$S4" area/devex type/chore status/ready

# === Sprint 5 ===
add_issue "feat(web): /reminders/new (form + validación)" "E.164; fecha futura; params dinámicos; UX simple." "$S5" area/web type/feat status/ready
add_issue "feat(web): POST → /v1/reminders + toasts" "RequestId; manejo de fallos." "$S5" area/web type/feat status/ready
add_issue "feat(web): /logs (últimos 50 MessageLog) + filtros" "Tabla simple; filtro por teléfono/fecha/estado." "$S5" area/web type/feat status/ready

# === Sprint 6 ===
add_issue "feat(api): POST /auth/login (JWT simple)" "Usuario hardcoded en .env; expiración; 401/403." "$S6" area/api type/feat status/ready
add_issue "feat(api): Guards JWT rutas sensibles" "Proteger creación/envío; e2e mínimos." "$S6" area/api type/feat status/ready
add_issue "feat(api): @nestjs/throttler (rate limiting)" "Headers de RL; límites; docs." "$S6" area/api type/feat status/ready

# === Sprint 7 ===
add_issue "test(api): unit + e2e (Jest) >=60%" "Cobertura rutas críticas: send, reminders, webhook, auth." "$S7" area/api type/test status/ready
add_issue "ci: GitHub Actions (lint/test/build)" "Pipeline verde en PR; cache PNPM." "$S7" area/devex type/chore status/ready
add_issue "chore(api): Dockerfile + Compose (local)" "Build reproducible; healthcheck; .dockerignore." "$S7" area/infra type/chore status/ready
add_issue "deploy: Railway/Render + env" "API pública para webhook; healthcheck." "$S7" area/infra type/feat status/ready
add_issue "docs: README (Quickstart + QA manual)" "Local/dev/prod; cURL test; .env.example." "$S7" area/devex type/docs status/ready

echo "✅ Tablero listo. Abre tu Project en GitHub → Projects: \"$TITLE\""
