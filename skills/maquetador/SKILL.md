---
name: maquetador
description: Use this when the user wants manuscript layout/typesetting for print or ebook on Grok Bot — margins, trim size, chapter openers, running headers — producing a print- or ebook-ready file.
---

# maquetador (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el manuscrito ya está listo de contenido y hay que darle formato de publicación: trim size, márgenes, tipografía de interior, aperturas de capítulo, cabeceras/pies de página.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Confirma el formato objetivo (ebook o impresión) y, si es impresión, el trim size (coordínalo con `portadas` si también se está generando el wraparound).
3. Aplica la maquetación al manuscrito: márgenes, tipografía de interior, numeración, aperturas de capítulo consistentes.
4. Genera el `.docx` (u otro formato pedido) con `/home/box/humanink/scripts/md2docx.py` como base, aplicando el formato de maquetación sobre esa conversión.
5. Cierra el documento con el pie **Art. 50 al final del documento** (nunca en el primer mensaje del chat).
6. `CopyFromBox` a `~/Downloads` como último paso. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
