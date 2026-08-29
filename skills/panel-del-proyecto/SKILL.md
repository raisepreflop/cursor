---
name: panel-del-proyecto
description: Use this when the user wants a visual dashboard of AWAP project health on Grok Bot. Regenerates it with the local build_dashboard.py script instead of calling the awap_dashboard MCP tool, which does not exist on this box.
---

# panel-del-proyecto (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*` (incluido `awap_dashboard`), `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere una vista visual (no solo texto) del progreso AWAP de un proyecto: tendencia de sesiones, proporción humano/IA en el tiempo, hitos.

## Por qué es distinto de Claude Cowork

Claude Cowork genera el dashboard llamando `awap_dashboard` contra el servidor MCP. Grok Bot no tiene ese servidor: este skill usa el script local `build_dashboard.py` para producir el panel a partir de `.awap/log.jsonl`.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Confirma que `.awap/project.json` y `.awap/log.jsonl` existen para el proyecto (si no, corre primero `proyecto-awap`/`escritura-awap`).
3. Ejecuta `build_dashboard.py` (ruta canónica bajo `/home/box/humanink/scripts/` o la que indique la instalación local del box) apuntando a la carpeta `.awap/` del proyecto.
4. El script produce el panel como HTML/PNG estático — revísalo antes de entregar (que las series de datos y el rango de fechas correspondan al proyecto correcto).
5. Comparte el panel en el chat como imagen o enlace al archivo generado. Si el usuario pide el panel embebido en un reporte de Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
