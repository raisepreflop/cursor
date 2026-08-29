---
name: copywriter
description: Use this when the user needs marketing copy (back-cover blurb, ad copy, landing page copy) for a book on Grok Bot. If no briefing is supplied, extract one directly from the manuscript and continue — never stop the conversation to demand a briefing document.
---

# copywriter (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario pide copy de marketing para un libro: contraportada, copy de anuncio, texto de landing, gancho de ventas.

## Regla clave

**Si no hay briefing, no te detengas a pedirlo.** Extrae el briefing implícito directamente del manuscrito (premisa, tono, público objetivo, ganchos narrativos ya presentes en el texto) y continúa produciendo el copy con eso. Solo pide aclaración si el manuscrito mismo es insuficiente para inferir un briefing razonable (por ejemplo, si solo hay un título sin contenido).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Busca un briefing explícito del proyecto (`estado.json`, notas del autor, mensaje del usuario). Si existe, úsalo.
3. Si no hay briefing, lee el manuscrito disponible y extrae: premisa, género, tono, público objetivo, y 2-3 ganchos narrativos fuertes. Trátalo como el briefing efectivo y sigue adelante sin pausar la conversación.
4. Redacta el copy pedido (contraportada, anuncio, landing) ajustado al formato solicitado.
5. Entrega el copy en el chat. Si el usuario pide el documento formal en Word, genera el `.docx` con `md2docx.py`, cierra con el pie Art. 50, y termina con `CopyFromBox` a `~/Downloads` (1:1 si la conversación es grupal).
