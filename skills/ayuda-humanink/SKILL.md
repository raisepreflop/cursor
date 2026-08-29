---
name: ayuda-humanink
description: Use this when a user or another agent asks how HumanInk / AWAP works on Grok Bot, or expects the awap_* MCP tool descriptions and doesn't find them. Serves the real-agent cheat sheet documenting the on-disk layout and canonical scripts instead.
---

# ayuda-humanink (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando un usuario (o un agente colaborador) pregunta "¿cómo funciona esto?", "¿qué comandos hay?", o específicamente busca las herramientas `awap_*` que existen en Claude Cowork y no las encuentra en Grok Bot.

## Cheat sheet del agente real (Grok Bot)

No hay servidor MCP `awap_*` en este box. Esto es lo que hay en su lugar:

| Si buscabas... | Usa esto en Grok Bot |
| --- | --- |
| `awap_init` / `awap_set_project` | skill `proyecto-awap` → escribe `.awap/project.json` |
| `awap_session_start` / `awap_session_end` / `awap_log_event` / `awap_log_telemetry` | skill `escritura-awap` → append a `.awap/log.jsonl` |
| `awap_sign` / `awap_report` / `awap_score` | skill `certificado-awap` → score calculado localmente + PDF de borrador vía Chrome |
| `awap_dashboard` | skill `panel-del-proyecto` → `build_dashboard.py` local |
| `awap_activate`, `awap_register`, `awap_sync`, `awap_ping`, `awap_status`, `awap_list_projects`, `awap_declare_baseline` | No tienen equivalente activo aquí; `activate`/license-gate no se portaron a este overlay |

Además:

- Runtime: `source /home/box/humanink/env.sh` antes de cualquier skill.
- Scripts canónicos: `/home/box/humanink/scripts/md2docx.py`, `/home/box/humanink/scripts/ai-parser/parser.py`. `~/.awos` no es el único path válido; `~/ClaudeCo` no existe aquí.
- Colaboradores son agentes Grok (Irene, Paul, Ricardo…), no comandos `/humanink:*`.
- Rol 15 (ads) no está portado.
- El mapa completo de todos los skills vive en [`GROK-BOT.md`](../../GROK-BOT.md) en la raíz del repo.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Identifica qué está buscando el usuario/agente (¿un comando `awap_*` específico? ¿el layout general? ¿por qué falló algo?).
3. Responde con la fila correspondiente de la tabla de arriba, o con el resumen completo si la pregunta es general.
4. Si la pregunta apunta a un skill específico, dirige al usuario/agente al `SKILL.md` de ese skill en `skills/`, no a un `SKILL.md` de Claude Cowork.
5. Este skill responde en el chat; no produce un `.docx`, así que no aplica `CopyFromBox` ni pie Art. 50.
