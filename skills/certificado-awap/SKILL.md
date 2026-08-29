---
name: certificado-awap
description: Use this when the user needs an AWAP authorship certificate for a finished manuscript on Grok Bot. Renders it as a Chrome-printed draft PDF from data read out of .awap/, instead of calling the awap_sign / awap_report / awap_score MCP tools, which do not exist on this box.
---

# certificado-awap (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*` (incluidos `awap_sign`, `awap_report`, `awap_score`), `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando un proyecto con historial en `.awap/log.jsonl` está terminado (o en un hito significativo) y el autor necesita un certificado de autoría human/IA para acompañar el manuscrito.

## Por qué es distinto de Claude Cowork

Claude Cowork genera el certificado firmando/puntuando/reportando vía `awap_sign`, `awap_score` y `awap_report` contra un servidor MCP. Grok Bot no tiene ese servidor: este skill calcula el score localmente a partir de `.awap/log.jsonl` y renderiza el certificado como un **PDF de borrador impreso desde el navegador de Grok (Chrome)**, no como un artefacto firmado remotamente.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee `.awap/project.json` y todas las líneas de `.awap/log.jsonl` del proyecto.
3. Calcula el score de autoría (proporción humano/IA agregada, número de sesiones, palabras netas) a partir de esos datos locales — sin llamar ningún `awap_*` MCP.
4. Genera una vista HTML del certificado (nombre del proyecto/autor, score calculado, rango de fechas, resumen de sesiones) y ábrela con el navegador de Grok.
5. Imprime esa vista a PDF desde Chrome (Ctrl/Cmd+P → Guardar como PDF) — este PDF es explícitamente un **borrador**, no un documento firmado criptográficamente; díselo al usuario en el chat.
6. Guarda el PDF resultante y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
7. El pie Art. 50 va al final del certificado (última página), nunca en el chat.
