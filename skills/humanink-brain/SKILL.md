---
name: humanink-brain
description: Use this when it's unclear which HumanInk skill on Grok Bot should handle a request — this is the router/orchestrator that reads the ask and points to the right skill (or chains a few), without executing steps that belong to another skill's SKILL.md itself.
---

# humanink-brain (Grok Bot)

> **Overlay Grok Bot — wrapper Grok-only.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Cuando la petición del usuario no mapea obviamente a un solo skill, o involucra varios pasos que pertenecen a distintos skills (por ejemplo: "prepara todo para publicar este manuscrito" puede tocar `corrector`, `portadas`, `verificador-de-versiones` y `auditor-kdp`).

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Lee la petición del usuario y clasifícala contra el índice de skills de [`GROK-BOT.md`](../../GROK-BOT.md) (sección 5).
3. Si mapea a un solo skill, indícalo y pasa la ejecución a ese `SKILL.md` — no dupliques ni reimplementes sus pasos aquí.
4. Si la petición requiere varios skills en secuencia, propone el orden (por ejemplo: `escritor-fantasma` → `corrector` → `verificador-de-versiones` → `portadas` → `auditor-kdp`) y ejecuta cada skill como su propio paso, en su propio turno — `humanink-brain` orquesta, no reemplaza el procedimiento de cada skill.
5. Si la petición no tiene skill correspondiente en este overlay (por ejemplo, algo del rol 15/ads, o `activate`/license-gate), dilo explícitamente en vez de improvisar un flujo nuevo.
6. Este skill responde en el chat; no produce un `.docx` propio, así que no aplica `CopyFromBox` ni pie Art. 50 salvo que el skill delegado sí lo requiera.
