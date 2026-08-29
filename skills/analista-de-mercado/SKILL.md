---
name: analista-de-mercado
description: Use this when the user wants market/competitive analysis for a book or genre on Grok Bot, including the optional --digest-semanal mode that produces a recurring weekly market digest instead of a one-off report.
---

# analista-de-mercado (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere entender el mercado de su género/nicho: comparables, precios típicos, categorías competitivas, tendencias de demanda.

## Modo `--digest-semanal`

Si se invoca con `--digest-semanal`, este skill no produce un análisis puntual sino un **digest recurrente semanal**: mismo tipo de análisis pero acotado a la ventana de la última semana, pensado para repetirse cada semana como seguimiento continuo del mercado del proyecto. (Nota: este digest es distinto y no se mezcla con `corrector`, que explícitamente no incluye ningún digest de mercado.)

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Determina el alcance: análisis puntual (por defecto) o `--digest-semanal` (ventana de 7 días).
3. Reúne comparables y señales de mercado relevantes al género/nicho del proyecto (puede apoyarse en `auditor-kdp` para leer listings reales cuando se necesite un comparable específico).
4. Redacta el análisis: comparables, rango de precios, categorías/keywords competitivas, y una recomendación breve.
5. Entrega el análisis en el chat. Si el usuario pide el reporte en Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
