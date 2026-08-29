---
name: escritor-fantasma
description: Use this when the user wants a ghostwriting pass or new edition of a manuscript produced on Grok Bot. Accepts --edicion N to target a specific edition and defaults to --freeze-original so the source file is never overwritten unless explicitly told not to freeze.
---

# escritor-fantasma (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio de voz narrativa, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario pide que se escriba o reescriba contenido de un manuscrito en su nombre (capítulo nuevo, reescritura de una escena, una edición completa), manteniendo su voz.

## Flags clave

- `--edicion N`: identifica en qué edición numerada del manuscrito se está trabajando. Todo output de esta corrida se etiqueta con esa edición (en el nombre de archivo y en cualquier metadata interna).
- `--freeze-original` (**por defecto activo**): el archivo fuente original nunca se sobrescribe. La salida siempre va a un archivo nuevo (`manuscrito.edicion-N.docx` o similar). Solo si el usuario pide explícitamente lo contrario se desactiva este freeze, y aun así debes confirmarlo antes de sobrescribir.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Confirma la edición (`--edicion N`) sobre la que se trabaja y si el freeze del original aplica (por defecto sí).
3. Registra en AWAP si corresponde: si el proyecto usa `escritura-awap`, marca el tramo generado como asistido por IA con el volumen correspondiente.
4. Escribe o reescribe el contenido pedido, manteniendo la voz y estilo ya establecidos del autor (perfil de `perfil-de-autor` si existe).
5. Convierte a `.docx` con `/home/box/humanink/scripts/md2docx.py`, respetando el nombre de archivo con la edición marcada y sin tocar el original si el freeze está activo.
6. Cierra el documento con el pie Art. 50 al final del Word (nunca en el chat).
7. `CopyFromBox` a `~/Downloads` como último paso. Si la conversación es un grupo, entrega en 1:1 — los adjuntos en salas llegan vacíos.
