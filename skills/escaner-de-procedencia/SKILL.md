---
name: escaner-de-procedencia
description: Use this when the user wants to check a manuscript or file for AI-provenance signals (Unicode homoglyphs/anomalies, C2PA content-credentials metadata) on Grok Bot, using procedencia.py to scan and report — the report explicitly identifies the scanning agent as Grok, not Claude.
---

# escaner-de-procedencia (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; cualquier equivalente de Claude Cowork se lee solo por criterio/tono. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario quiere saber si un archivo (manuscrito, imagen, PDF) tiene señales de procedencia relevantes: caracteres Unicode anómalos u homoglifos que sugieran texto generado o manipulado, y/o metadata C2PA (Content Credentials) que indique herramientas de creación/edición usadas.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Ejecuta `procedencia.py` sobre el archivo indicado:
   - Escaneo Unicode: detecta homoglifos, caracteres de control invisibles, espacios anómalos y otras señales típicas de texto generado o post-procesado.
   - Escaneo C2PA: lee metadata de Content Credentials embebida (si el formato del archivo la soporta) y reporta la cadena de herramientas/edición declarada.
3. Consolida ambos escaneos en un solo reporte con: hallazgos Unicode, hallazgos C2PA, y un veredicto de riesgo (bajo/medio/alto) con la evidencia concreta que lo sustenta.
4. **El reporte debe declarar explícitamente que el escaneo lo hizo Grok, no Claude.** Es un dato de procedencia del propio reporte: quién auditó, con qué agente, y cuándo. No omitas ni oscurezcas este dato.
5. Entrega el reporte en el chat. Si el usuario pide el documento formal, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
