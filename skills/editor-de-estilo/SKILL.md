---
name: editor-de-estilo
description: Use this when the user wants a line-edit / style pass on Grok Bot — voice, rhythm, word choice, sentence variety — distinct from the copyedit-only scope of corrector and from the structural scope of editor-de-desarrollo.
---

# editor-de-estilo (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere mejorar el estilo a nivel de línea — voz, ritmo, variedad de oración, elección de palabras — sin entrar en corrección ortográfica/gramatical pura (`corrector`) ni en reestructuración de trama (`editor-de-desarrollo`).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el fragmento y evalúa: monotonía de ritmo, repetición de palabras/muletillas, consistencia de voz respecto al resto del manuscrito.
3. Reescribe a nivel de línea preservando el sentido, mejorando ritmo y variedad, y manteniendo la voz establecida del autor.
4. Entrega el texto editado en el chat, idealmente señalando los cambios más relevantes y por qué.
5. Si el usuario pide el resultado como documento Word: convierte con `md2docx.py`, marca los cambios como control de cambios OOXML igual que `corrector`, cierra con el pie **Art. 50 al final del documento**, y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
