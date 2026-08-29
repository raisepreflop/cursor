---
name: escritura-awap
description: Use this when logging a writing session's human/AI authorship split for an AWAP-tracked project on Grok Bot. Appends structured entries to .awap/log.jsonl instead of calling the awap_session_start / awap_session_end / awap_log_event / awap_log_telemetry MCP tools, which do not exist on this box.
---

# escritura-awap (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*` (incluidos `awap_session_start`, `awap_session_end`, `awap_log_event`, `awap_log_telemetry`), `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Durante o al cerrar una sesión de escritura/edición sobre un proyecto con `.awap/` inicializado (ver `proyecto-awap`), para registrar cuánto del contenido de esa sesión es autoría humana vs. asistida por IA.

## Por qué es distinto de Claude Cowork

Claude Cowork registra el ciclo de vida de la sesión (`awap_session_start` → eventos/telemetría intermedios vía `awap_log_event`/`awap_log_telemetry` → `awap_session_end`) contra un servidor MCP. Grok Bot no tiene ese servidor: el mismo ciclo se registra como líneas JSON append-only en `.awap/log.jsonl`.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Confirma que `.awap/project.json` existe (si no, corre primero `proyecto-awap`).
3. Al iniciar la sesión, agrega una línea a `.awap/log.jsonl` con `{"tipo": "session_start", "ts": <iso8601>, "clave_proyecto": ...}`.
4. Durante la sesión, cada evento relevante (por ejemplo: tramo escrito por el autor, tramo generado/asistido, edición sustancial) se agrega como una línea adicional en el mismo archivo, con al menos `tipo`, `ts`, y una estimación de origen (`humano` / `ia` / `mixto`) y volumen (palabras o caracteres).
5. Al cerrar la sesión, agrega una línea `{"tipo": "session_end", "ts": <iso8601>, "resumen": {...}}` con el resumen agregado de la sesión (proporción humano/IA, duración, palabras netas).
6. `.awap/log.jsonl` es append-only: nunca reescribas ni reordenes líneas anteriores, solo agrega al final.
7. Confirma en el chat el resumen de la sesión registrada. No hay llamada a ningún `awap_*` MCP en ningún paso. Este skill no produce un `.docx`; no aplica `CopyFromBox` ni pie Art. 50.
