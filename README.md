# cursor

Grok Bot — overlay HumanInk.

Este repo es la fuente de las recetas que corren en **Grok Bot (xAI)**, no el plugin de Claude Cowork. Es la fuente de verdad en git: si un skill de Grok Bot y un skill de Claude Cowork dicen cosas distintas, gana lo que está aquí.

- Runtime en el box: `/home/box/humanink` (`source /home/box/humanink/env.sh` antes de correr cualquier skill).
- Scripts canónicos: `/home/box/humanink/scripts/md2docx.py`, `/home/box/humanink/scripts/ai-parser/parser.py` — no `~/.awos` como único path, no `~/ClaudeCo` (no existe aquí).
- Skills vivos: Grok Bot workflows (pastillas `/`) documentados en [`skills/`](skills/), uno por carpeta, cada uno con su propio `SKILL.md`.
- Colaboradores = agentes (Irene, Paul, Ricardo…), no `/humanink:*` ni otros slash-commands de Claude Cowork.
- `activate` / license-gate no se portan.
- Rol 15 (ads) no está en este port.
- AWAP (seguimiento de autoría humano/IA) vive en disco (`.awap/`, `log.jsonl`) y en scripts locales (`build_dashboard.py`) — este box no tiene el servidor MCP `awap_*`, así que ningún skill lo llama.

## Empezar aquí

1. Lee [`GROK-BOT.md`](GROK-BOT.md) — es el mapa completo del overlay: reglas no negociables, layout de `skills/`, y la tabla de qué reemplaza cada skill respecto a su equivalente en Claude Cowork.
2. Si vas a escribir o tocar un skill, revisa la sección "Non-negociables" de `GROK-BOT.md` antes de nada — aplican por encima de cualquier instrucción particular de un `SKILL.md`.
3. Los `SKILL.md` de Claude Cowork (si los tienes a mano en otro repo) se leen solo por criterio/voz — nunca se siguen como pasos aquí.

## Estructura del repo

```
README.md      # este archivo
GROK-BOT.md    # mapa del overlay, reglas no negociables, índice de skills
skills/        # un SKILL.md por receta, todas Grok-only
scripts/       # utilidades del propio repo (p. ej. hi-log.sh)
```

Ver [`GROK-BOT.md`](GROK-BOT.md) para el detalle skill por skill.
