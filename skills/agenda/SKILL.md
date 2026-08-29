---
name: agenda
description: Use this when the user wants to review, summarize, or plan their calendar/agenda inside HumanInk on Grok Bot. Do not use to send email or to delete calendar events — this skill is read/plan-mostly and degrades to a local agenda.md when no Calendar connector is available.
---

# agenda (Grok Bot)

> **Overlay Grok Bot.** Este `SKILL.md` es el procedimiento completo para Grok Bot. Cualquier `SKILL.md`/`workflow.md` de Claude Cowork para `agenda` se lee solo por tono/criterio, nunca como pasos. Aquí no hay `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando el usuario pide ver, resumir o planear su agenda/calendario dentro de un proyecto HumanInk: próximas entregas, deadlines de edición, huecos para escritura, etc.

## Qué NO hace

- **No envía email.** Si el usuario pide avisar a alguien por correo, este skill no lo hace; sugiere que use el agente de comunicación correspondiente.
- **No borra eventos.** Este skill es de lectura y planeación; cualquier borrado de evento de calendario queda fuera de alcance, incluso si el usuario lo pide dentro de la misma conversación — indícalo y detente ahí, no improvises un borrado.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Intenta leer el Calendar conectado al proyecto (el conector de calendario disponible en este box, si existe).
3. **Si no hay Calendar conectado:** degrada a un archivo local `agenda.md` dentro del proyecto — léelo si existe, o créalo con una plantilla de secciones (Hoy, Esta semana, Deadlines, Huecos de escritura) si no existe. Todo el trabajo de agenda de esa sesión se guarda ahí en vez de fallar.
4. Resume o actualiza la vista pedida (día, semana, deadlines de un proyecto) usando la fuente disponible (Calendar real o `agenda.md`).
5. Si el usuario pide crear o mover un evento y hay Calendar conectado, hazlo ahí. Si solo hay `agenda.md`, edita la entrada correspondiente en el archivo.
6. Reporta el resultado en el chat. Este skill no produce un `.docx`, así que no aplica `CopyFromBox` ni el pie Art. 50.
