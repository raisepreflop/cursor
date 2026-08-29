---
name: coach-literario
description: Use this when the user wants literary coaching or brainstorming on Grok Bot to shape a book idea. Takes the premise directly from the chat message and never stops the conversation to demand a premisa.md file before continuing.
---

# coach-literario (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere ayuda para desarrollar una idea de libro, superar un bloqueo creativo, o recibir retroalimentación tipo coaching sobre su proceso de escritura.

## Regla clave

**La premisa vive en el mensaje, no en un archivo.** Este skill toma la premisa directamente de lo que el usuario escribió en el chat y continúa la conversación de inmediato. Nunca se detiene a exigir que exista un `premisa.md` antes de avanzar, ni bloquea el coaching esperando que el usuario formalice la idea en disco primero.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Toma la premisa/idea tal como la describió el usuario en el mensaje (aunque sea informal o incompleta) y trabaja con eso.
3. Si conviene guardar la premisa para referencia futura, escríbela en `premisa.md` **como consecuencia** de la conversación (para no perderla), pero nunca como condición previa para empezar a ayudar.
4. Ofrece preguntas de coaching, estructura, o ejercicios según lo que el usuario necesite (desbloqueo, estructura de trama, desarrollo de personajes).
5. Este skill normalmente responde en el chat; no produce un `.docx`. Si el usuario pide un resumen del coaching en Word, genera el documento con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
