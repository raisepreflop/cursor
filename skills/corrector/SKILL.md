---
name: corrector
description: Use this when the user wants a copyedit/proofreading pass on a manuscript on Grok Bot. Converts Markdown to Word with md2docx.py --read, marks changes as OOXML tracked changes, and never runs a market digest as part of this skill.
---

# corrector (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el `SKILL.md`/`workflow.md` de Claude Cowork para `corrector` se lee solo por tono/criterio de qué cuenta como "buena corrección", nunca como pasos a ejecutar. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect. El colaborador de corrección es un agente (p. ej. Irene), no un comando `/corrector` — si necesitas una segunda opinión, habla con ese agente directamente.

## Cuándo usar este skill

Cuando el usuario pide una pasada de corrección de estilo/ortografía/gramática sobre un manuscrito en Markdown, con salida en Word y cambios visibles como control de cambios.

## Qué NO hace

Este skill **no** incluye un digest de mercado ni análisis de tendencias — eso es responsabilidad de `analista-de-mercado`. Mantén el alcance solo en corrección.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el manuscrito en Markdown y aplica la corrección (ortografía, gramática, puntuación, consistencia de estilo) directamente sobre el texto.
3. Genera el `.docx` con:
   ```
   /home/box/humanink/scripts/md2docx.py --read <manuscrito.md> --out <salida.docx>
   ```
   **Nunca** uses `npx mammoth` ni ninguna otra ruta de conversión — `md2docx.py --read` es la única vía canónica en este overlay.
4. Marca cada cambio de corrección como **cambio de control OOXML** (tracked change nativo del `.docx`), no como comentarios sueltos ni resaltado manual — así el autor puede aceptar/rechazar cambio por cambio en Word.
5. Cierra el documento con el pie Art. 50 al final del Word (nunca en el primer mensaje del chat).
6. `CopyFromBox` a `~/Downloads` como último paso. Si la conversación es un grupo, entrega el archivo en 1:1 con el usuario — los adjuntos en salas llegan vacíos.
