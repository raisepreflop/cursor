---
name: humanizador
description: Use this when the user wants AI-sounding prose smoothed into a more natural, human register on Grok Bot — rhythm, contractions, imperfection where appropriate — without changing meaning or facts.
---

# humanizador (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando un texto (propio o generado por IA) suena mecánico, repetitivo o "de IA", y el usuario quiere que se lea como escrito por una persona, sin cambiar el contenido ni los hechos.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el texto a humanizar y detecta patrones típicos de IA: muletillas repetidas, estructuras de oración uniformes, exceso de conectores formales, falta de variación de ritmo.
3. Reescribe ajustando ritmo, longitud de oración, y elección de palabras hacia un registro más natural — preservando el significado, los datos y la voz ya establecida del autor (si existe perfil en `perfil-de-autor`).
4. Entrega el texto ajustado en el chat.
5. Si el usuario pide el resultado como documento Word: convierte con `/home/box/humanink/scripts/md2docx.py`, cierra con el pie **Art. 50 al final del documento** (nunca en el primer mensaje del chat), y termina con `CopyFromBox` a `~/Downloads`. Si la conversación es un grupo, entrega el archivo en 1:1 — los adjuntos en salas llegan vacíos.
