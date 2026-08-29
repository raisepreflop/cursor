---
name: perfil-de-autor
description: Use this when onboarding a new author or updating an existing author profile for HumanInk on Grok Bot. Runs a Spanish-language interview, persists answers to estado.json, and declares the project via proyectos.py declarar --nombre --clave.
---

# perfil-de-autor (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por criterio/tono, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando hay que crear el perfil inicial de un autor/autora nuevo en HumanInk, o actualizar uno existente (biografía, voz, géneros, público objetivo, pseudónimo).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Corre la entrevista **siempre en español**, sin importar el idioma en que llegó el mensaje del usuario — es la voz canónica del perfil de autor en este overlay. Cubre como mínimo: nombre/pseudónimo, biografía breve, géneros/temas, tono de voz, público objetivo, y obras previas relevantes.
3. Persiste cada respuesta incrementalmente en `estado.json` del proyecto del autor (no esperes a tener todas las respuestas para escribir; guarda a medida que avanzas para no perder progreso si la sesión se corta).
4. Al cerrar la entrevista, declara o actualiza el proyecto ejecutando:
   ```
   proyectos.py declarar --nombre "<nombre del autor/proyecto>" --clave "<clave interna del proyecto>"
   ```
5. Confirma en el chat el resumen del perfil guardado y la clave de proyecto usada. Este skill normalmente no produce un `.docx`; si el usuario pide una ficha de autor en Word, genera el documento con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
