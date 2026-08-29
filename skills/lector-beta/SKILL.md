---
name: lector-beta
description: Use this when the user wants fast, informal beta-reader style feedback on a chapter or draft on Grok Bot — quicker and lighter than the full lector-profesional dossier.
---

# lector-beta (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere una reacción rápida de "lector real" sobre un capítulo o borrador — qué funcionó, qué confundió, dónde se perdió el interés — sin el nivel de formalidad de un dossier completo (para eso está `lector-profesional`).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el fragmento indicado como lo leería un lector, no un editor: reacciones espontáneas, momentos que engancharon, momentos que aburrieron o confundieron.
3. Organiza la retroalimentación en 3-5 puntos concretos, sin la estructura de dossier de `lector-profesional` (no hay secciones numeradas ni veredicto formal).
4. Entrega la retroalimentación en el chat.
5. Si el usuario pide el resultado como documento Word: convierte con `md2docx.py`, cierra con el pie **Art. 50 al final del documento** (nunca en el chat), y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
