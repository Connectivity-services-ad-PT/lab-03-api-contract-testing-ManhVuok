#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-gate}"

case "${MODE}" in
  gate)
    npx prism mock contracts/access-gate.openapi.yaml -p 4010 --host 0.0.0.0
    ;;
  core)
    npx prism mock contracts/core-business.openapi.yaml -p 4011 --host 0.0.0.0
    ;;
  all)
    npm run mock:gate &
    GATE_PID=$!
    npm run mock:core &
    CORE_PID=$!
    trap 'kill ${GATE_PID} ${CORE_PID} 2>/dev/null || true' EXIT
    wait
    ;;
  *)
    echo "Usage: scripts/start-prism-mock.sh [gate|core|all]"
    exit 1
    ;;
esac
