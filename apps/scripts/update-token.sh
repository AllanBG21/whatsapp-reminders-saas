#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="apps/api/.env"
VAR_NAME="WABA_TOKEN"

usage() {
  echo "Uso: $0 <NUEVO_TOKEN> [--run]"
  echo "  --run   Inicia la API (foreground) tras actualizar el token"
  exit 1
}

[[ $# -ge 1 ]] || usage
NEW_TOKEN="$1"
RUN_FLAG="${2-}"

[[ -f "$ENV_FILE" ]] || { echo "No existe $ENV_FILE"; exit 1; }

# Backup con timestamp
TS="$(date +%Y%m%d-%H%M%S)"
cp "$ENV_FILE" "${ENV_FILE}.bak.$TS"

# Escapar caracteres especiales para sed (/, &)
escape_sed() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}
SAFE_TOKEN="$(escape_sed "$NEW_TOKEN")"

# Reemplazar si existe, si no, añadir al final
if grep -qE "^${VAR_NAME}=" "$ENV_FILE"; then
  sed -i "s/^${VAR_NAME}=.*/${VAR_NAME}=${SAFE_TOKEN}/" "$ENV_FILE"
else
  printf '\n%s=%s\n' "$VAR_NAME" "$NEW_TOKEN" >> "$ENV_FILE"
fi

# Mostrar confirmación (token enmascarado)
MASKED="${NEW_TOKEN:0:6}****${NEW_TOKEN: -4}"
echo "✅ ${VAR_NAME} actualizado en ${ENV_FILE} → ${MASKED}"
echo "🗃  Backup: ${ENV_FILE}.bak.$TS"

# Opción para iniciar API (foreground)
if [[ "${RUN_FLAG}" == "--run" ]]; then
  echo "🚀 Iniciando API en primer plano (Ctrl+C para detener)..."
  pnpm -C apps/api start:dev
else
  echo "ℹ️ Reinicia tu API para que tome el nuevo token:"
  echo "   pnpm -C apps/api start:dev"
fi
