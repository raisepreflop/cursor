---
name: editor-de-desarrollo
description: Use this when the user wants developmental editing (structure, plot, pacing, character arcs) on Grok Bot. "Roger" in this skill's notes refers to the chapter plan artifact it maintains for the project, not a person or collaborator.
---

# editor-de-desarrollo (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio editorial, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario necesita retroalimentación o rediseño a nivel de estructura del manuscrito: arco de personajes, ritmo, orden de capítulos, subtramas.

## Aclaración de vocabulario

**"Roger" es el plan de capítulos**, no un colaborador ni un agente. Cuando este skill (o sus notas internas) mencionan "Roger", se refieren al artefacto de plan de capítulos que el skill mantiene y actualiza para el proyecto — no a una persona a la que consultar ni a un rol externo. Evita cualquier confusión con los colaboradores reales del overlay (agentes como Irene).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Localiza o crea el plan de capítulos ("Roger") del proyecto: un documento (Markdown o el formato que use el proyecto) con la lista de capítulos, su función en la trama, y su estado (borrador/revisado/final).
3. Lee el manuscrito actual y compáralo contra el plan de capítulos: detecta huecos de ritmo, subtramas sin resolver, arcos de personaje inconsistentes.
4. Actualiza el plan de capítulos con los hallazgos y las recomendaciones de reestructuración.
5. Redacta el reporte de edición de desarrollo con los hallazgos priorizados y acciones concretas por capítulo.
6. Entrega el reporte en el chat. Si el usuario pide el reporte (y el plan de capítulos actualizado) en Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
