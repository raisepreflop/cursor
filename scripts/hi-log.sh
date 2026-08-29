#!/usr/bin/env bash
# hi-log.sh — patch-notes logger for the HumanInk Grok Bot overlay.
#
# Grok-only wrapper: forwards patch notes to the canonical logger at
# $HUMANINK_ROOT/skills/log/scripts/awos-log.py (see skills/registro-humanink/SKILL.md
# and skills/log/scripts/ for the script itself). This script does not talk to any
# Claude Cowork MCP tool and does not assume ~/.awos or ~/ClaudeCo exist.
#
# Usage:
#   ./scripts/hi-log.sh "patch note text goes here"
#   echo "patch note text" | ./scripts/hi-log.sh
set -euo pipefail

: "${HUMANINK_ROOT:=/home/box/humanink}"

ENV_FILE="$HUMANINK_ROOT/env.sh"
if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

LOGGER="$HUMANINK_ROOT/skills/log/scripts/awos-log.py"

if [ ! -f "$LOGGER" ]; then
  echo "hi-log.sh: no encuentro $LOGGER — revisa skills/log/scripts/ o HUMANINK_ROOT" >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
  NOTE="$*"
else
  NOTE="$(cat)"
fi

python3 "$LOGGER" --event patch-note --message "$NOTE"
