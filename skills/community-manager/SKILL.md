---
name: community-manager
description: Use this when the user wants social media copy or a posting plan for a book launch/campaign on Grok Bot — post drafts, captions, a content calendar — not paid ads (role 15 / ads is not ported here).
---

# community-manager (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect. **Rol 15 (ads) no existe en este port** — este skill no gestiona anuncios pagos, solo contenido orgánico.

## Cuándo usar este skill

Cuando el usuario necesita contenido para redes sociales alrededor de un libro: posts, captions, calendario de publicaciones para el lanzamiento o campaña.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Confirma canales objetivo y ventana de tiempo de la campaña.
3. Si no hay briefing explícito, extrae ganchos del manuscrito o del copy ya generado por `copywriter` (mismo criterio que `copywriter`: no detener la conversación a pedir un briefing formal).
4. Redacta los posts/captions y, si se pide, un calendario de publicación simple (fecha, canal, texto).
5. Si el usuario pide anuncios pagos, indícale explícitamente que ese rol (ads) no está portado en este overlay — no lo improvises.
6. Entrega el contenido en el chat. Si el usuario pide el plan como documento Word: convierte con `md2docx.py`, cierra con el pie **Art. 50 al final del documento**, y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
