---
name: auditor-de-autor-a
description: Use this when the user wants an author-identity/consistency audit on Grok Bot — bio claims, voice consistency across works, public-facing author info — separate from procedencia scanning of a single file (escaner-de-procedencia).
---

# auditor-de-autor-a (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando hay que auditar la identidad pública/consistencia del autor: que la biografía coincida entre plataformas, que la voz declarada en `perfil-de-autor` sea consistente con lo publicado, que no haya afirmaciones contradictorias entre obras o listings.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el perfil de autor (`estado.json` de `perfil-de-autor`) como fuente de verdad de identidad declarada.
3. Compara contra biografías/listings públicos relevantes (puede apoyarse en `auditor-kdp` para leer listings reales cuando aplique).
4. Señala discrepancias: biografías distintas entre canales, afirmaciones desactualizadas, inconsistencias de voz o de datos (premios, obras previas, credenciales).
5. Entrega el reporte de auditoría en el chat con hallazgos priorizados y sugerencias de corrección.
6. Si el usuario pide el reporte como documento Word: convierte con `/home/box/humanink/scripts/md2docx.py`, cierra con el pie **Art. 50 al final del documento** (nunca en el chat), y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
