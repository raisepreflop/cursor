---
name: agente-literario
description: Use this when the user wants an agent-style pitch package on Grok Bot — query letter, synopsis, comps/comparables — to submit a manuscript to literary agents or publishers.
---

# agente-literario (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere preparar el paquete de presentación para agentes literarios o editoriales: query letter, sinopsis, comparables de mercado.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Reúne lo necesario: premisa/gancho, género, extensión del manuscrito, y comparables (puede apoyarse en `analista-de-mercado` para comparables reales).
3. Redacta la query letter (gancho, sinopsis breve, bio del autor tomada de `perfil-de-autor` si existe), la sinopsis extendida, y la lista de comparables.
4. Entrega el paquete en el chat.
5. Si el usuario pide el paquete como documento Word: convierte con `md2docx.py`, cierra con el pie **Art. 50 al final del documento**, y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
