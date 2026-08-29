---
name: portadas
description: Use this when the user wants an ebook cover or a full KDP paperback/hardcover wraparound composed on Grok Bot. Always uses compose-kdp-wrap.py — never the /humanink:cover CLI, which doesn't exist here.
---

# portadas (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio visual, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*` (incluido `/humanink:cover`), `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario pide una portada de ebook, o el wraparound completo (portada + lomo + contraportada) para impresión en KDP.

## Regla clave

**Solo `compose-kdp-wrap.py` compone la portada/wraparound.** Nunca se invoca `/humanink:cover` ni ninguna otra CLI equivalente de Claude Cowork — no existe en este box y no debe simularse.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Reúne las dimensiones necesarias: trim size, número de páginas (para calcular ancho del lomo en wraparound impreso), y los assets de arte/tipografía disponibles.
3. Ejecuta:
   ```
   /home/box/humanink/scripts/compose-kdp-wrap.py --trim <trim> --pages <n> --out <salida>
   ```
   ajustando los flags según lo que soporte el script para portada simple de ebook vs. wraparound completo de impresión.
4. Revisa la salida (dimensiones correctas, sangrado, zonas de seguridad de texto) antes de entregar.
5. Entrega la imagen/PDF de portada en el chat. Si además se pide una nota descriptiva en Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
