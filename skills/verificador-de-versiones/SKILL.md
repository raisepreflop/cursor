---
name: verificador-de-versiones
description: Use this when the user needs to verify that a delivered .docx matches the expected manuscript version/checksum on Grok Bot. Uses verify_docx.py exclusively — no other diff/verification path is valid for this skill.
---

# verificador-de-versiones (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por criterio/tono. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando hay que confirmar que un `.docx` entregado (o a punto de entregarse) corresponde exactamente a la versión esperada del manuscrito, sin cambios accidentales ni versiones cruzadas entre ediciones.

## Regla clave

**Solo `verify_docx.py`.** No se usa diff manual de texto, ni comparación visual, ni ningún otro script como fuente de verdad de verificación — si `verify_docx.py` no está disponible o falla, el skill reporta el fallo, no inventa un método alterno.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Identifica el `.docx` a verificar y la versión/checksum esperada (del registro del proyecto, `estado.json`, o lo que indique el usuario).
3. Ejecuta `verify_docx.py` contra el archivo y la referencia esperada.
4. Reporta el resultado tal cual lo da el script: coincide / no coincide, y el detalle que el script exponga (checksum, diferencias de estructura, metadata).
5. Si no coincide, no corrijas el archivo tú mismo dentro de este skill — reporta el resultado y sugiere qué skill de producción (`corrector`, `escritor-fantasma`, etc.) debería regenerar la versión correcta.
6. Este skill entrega su resultado en el chat; no produce un `.docx` propio, así que no aplica `CopyFromBox` ni pie Art. 50.
