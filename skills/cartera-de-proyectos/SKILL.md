---
name: cartera-de-proyectos
description: Use this when the user wants a portfolio/status rollup across every HumanInk project on Grok Bot. Always builds it via the absolute scripts /home/box/humanink/skills/projects/scripts/build_projects.py and /home/box/humanink/skills/projects/scripts/proyectos.py — never relative paths.
---

# cartera-de-proyectos (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere ver el estado de todos sus proyectos HumanInk a la vez: qué está activo, en qué etapa, y qué necesita atención.

## Regla clave

**Siempre rutas absolutas.** Este skill nunca asume que corre desde el directorio del proyecto de turno; usa explícitamente:

```
/home/box/humanink/skills/projects/scripts/build_projects.py
/home/box/humanink/skills/projects/scripts/proyectos.py
```

No uses rutas relativas (`./scripts/...` o similares) — el skill puede invocarse desde cualquier directorio de trabajo.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Ejecuta `proyectos.py listar` (o el subcomando equivalente de listado) usando la ruta absoluta de arriba para obtener el inventario de proyectos declarados.
3. Ejecuta `build_projects.py` (ruta absoluta) para consolidar el estado de cada proyecto en la cartera.
4. Presenta la cartera como tabla: nombre/clave del proyecto, etapa actual, última actividad, y pendientes relevantes.
5. Entrega el resumen en el chat. Si el usuario pide el reporte en Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
