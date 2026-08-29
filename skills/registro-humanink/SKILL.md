---
name: registro-humanink
description: Use this when the user wants a durable checkpoint of HumanInk project progress written to project-checkpoint.md on Grok Bot. Appends the checkpoint entry via the canonical script at skills/log/scripts/awos-log.py.
---

# registro-humanink (Grok Bot)

> **Overlay Grok Bot.** Procedimiento completo para Grok Bot; el equivalente de Claude Cowork se lee solo por tono/criterio, nunca como pasos. Sin `STOP`, MCP `awap_*`, `$ARGUMENTS`, `/humanink:*`, `HI-GATE`, Claude-in-Chrome ni Cowork Connect.

## Cuándo usar este skill

Al cerrar una sesión de trabajo significativa sobre un proyecto (una entrega, una decisión importante, un hito), para dejar un checkpoint legible por humanos y por otros agentes que retomen el proyecto después.

## Ruta canónica del logger

El script que escribe el checkpoint vive en:

```
skills/log/scripts/awos-log.py
```

(rutas relativas a la raíz de este repo/instalación; en el box, resuelto vía `$HUMANINK_ROOT/skills/log/scripts/awos-log.py`). También puedes invocarlo indirectamente con `scripts/hi-log.sh "<nota>"` desde la raíz del repo.

## Pasos

1. `source /home/box/humanink/env.sh`.
2. Redacta la nota de checkpoint: qué se hizo, qué decisiones quedaron tomadas, y qué sigue pendiente para la próxima sesión.
3. Ejecuta:
   ```
   python3 skills/log/scripts/awos-log.py --event checkpoint --message "<nota de checkpoint>"
   ```
   (o `./scripts/hi-log.sh "<nota de checkpoint>"` como wrapper equivalente).
4. Confirma que la nota quedó anexada a `project-checkpoint.md` del proyecto (el script debe encargarse de esa escritura; no edites el archivo a mano si el script está disponible).
5. Confirma en el chat que el checkpoint quedó guardado, citando la ruta del `project-checkpoint.md` actualizado. Este skill no produce un `.docx`; no aplica `CopyFromBox` ni pie Art. 50.
