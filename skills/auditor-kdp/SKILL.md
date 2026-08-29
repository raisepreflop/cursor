---
name: auditor-kdp
description: Use this when the user wants an audit of a live KDP (Kindle Direct Publishing) listing on Grok Bot — checking the actual public page for metadata, pricing, categories, and content issues. Always reads the real listing through the Grok browser tool, never through Claude-in-Chrome.
---

# auditor-kdp (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el `SKILL.md`/`workflow.md` de Claude Cowork equivalente se usa solo como referencia de criterio de calidad, no como pasos. No hay Claude-in-Chrome, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE` ni Cowork Connect en este box.

## Cuándo usar este skill

Cuando el usuario pide auditar un listing publicado en KDP: título, subtítulo, descripción, categorías, palabras clave, precio, portada, o cualquier combinación de estos, contra la versión real y en vivo del listing.

## Regla clave

Este skill **siempre navega el listing real** con el navegador de Grok Bot — nunca simula la página ni asume su contenido a partir de metadata local, y nunca delega la navegación a Claude-in-Chrome (esa herramienta no existe en Grok Bot).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Pide o confirma la URL del listing de KDP a auditar.
3. Abre la URL con el navegador de Grok Bot y lee la página real (no cacheada, no memorizada de una sesión anterior).
4. Extrae: título, subtítulo, descripción, categorías, palabras clave visibles, formato(s) disponibles, precio(s), y estado de la portada/miniatura.
5. Compara contra la ficha interna del proyecto (si existe) o contra buenas prácticas de KDP, y lista discrepancias o riesgos (categorías mal elegidas, descripción incompleta, keywords débiles, precio fuera de rango, etc.).
6. Entrega el reporte de auditoría en el chat como lista priorizada de hallazgos y acciones sugeridas.
7. Si el usuario pide el reporte como documento, genera un `.docx` con `/home/box/humanink/scripts/md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (entrega en 1:1 si la conversación es un grupo).
