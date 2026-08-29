---
name: proyecto-awap
description: Use this when starting or re-attaching an AWAP-tracked project on Grok Bot. Initializes and updates the project record on disk under .awap/project.json instead of calling the awap_init / awap_set_project MCP tools, which do not exist on this box.
---

# proyecto-awap (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*` (incluidos `awap_init`, `awap_set_project`, `awap_ping`), `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect. `activate`/license-gate no se portaron: este skill nunca pide activación.

## Cuándo usar este skill

Cuando hay que crear el registro AWAP de un proyecto nuevo, o re-conectar un proyecto existente a su registro AWAP en disco (por ejemplo, al retomar trabajo en otra sesión).

## Por qué es distinto de Claude Cowork

Claude Cowork gestiona el estado de AWAP a través de un servidor MCP (`awap_init`, `awap_set_project`, `awap_list_projects`, etc.). **Ese servidor no existe en Grok Bot.** Este skill logra lo mismo escribiendo directamente en disco, dentro del propio proyecto.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Localiza (o crea) la carpeta `.awap/` dentro del directorio del proyecto.
3. Si `.awap/project.json` no existe, créalo con al menos: `nombre`, `clave` (debe coincidir con la clave usada en `perfil-de-autor`/`proyectos.py declarar`), `fecha_inicio`, y `agente` (identifica que el proyecto se está trackeando desde Grok Bot).
4. Si `.awap/project.json` ya existe, léelo, valida que la clave coincida con el proyecto activo, y actualiza los campos que correspondan (por ejemplo, re-attach después de una pausa larga).
5. Confirma en el chat la ruta del `.awap/project.json` usado y un resumen de sus campos. No hay llamada a ningún `awap_*` MCP en ningún paso de este skill.
6. Este skill no produce un `.docx`; no aplica `CopyFromBox` ni pie Art. 50.
