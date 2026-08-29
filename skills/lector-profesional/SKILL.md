---
name: lector-profesional
description: Use this when the user wants a full professional beta-read dossier on Grok Bot, covering structure, voice, market fit, and a final verdict. The dossier's section 07 is the core verdict section — the whole deliverable is organized around it.
---

# lector-profesional (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio de qué cuenta como un buen dossier, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere una lectura profesional completa del manuscrito: no solo una corrección de línea, sino un dossier de evaluación con veredicto.

## Estructura del dossier

El dossier estándar tiene (al menos) estas secciones, numeradas:

1. Resumen ejecutivo
2. Sinopsis de trabajo
3. Estructura y ritmo
4. Personajes y voz
5. Fortalezas
6. Áreas de mejora
7. **Veredicto** — sección central de este dossier; concentra la recomendación final (publicar tal cual / publicar con revisiones / no está listo) y el razonamiento que la sostiene

La sección `07` no es una sección más: es el corazón del dossier, y las secciones anteriores deben construir hacia ella de forma coherente.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee el manuscrito completo (o el corte que el usuario indique) y toma notas por cada una de las secciones del dossier.
3. Redacta las secciones 1–6 con evidencia concreta del texto (citas breves, ejemplos, referencias de capítulo).
4. Redacta la sección **07 — Veredicto** de forma explícita y decidida, apoyada en lo desarrollado en las secciones anteriores.
5. Convierte el dossier a `.docx` con `/home/box/humanink/scripts/md2docx.py`.
6. Cierra el documento con el pie Art. 50 al final del Word (nunca en el chat).
7. `CopyFromBox` a `~/Downloads` como último paso. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
