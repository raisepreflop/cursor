# skills/log/scripts/

Este directorio documenta la ruta canónica de `awos-log.py`, el script que escriben `registro-humanink` y `scripts/hi-log.sh` para anexar checkpoints a `project-checkpoint.md`.

El script en sí se ejecuta desde el box de HumanInk en:

```
$HUMANINK_ROOT/skills/log/scripts/awos-log.py
```

(por defecto `HUMANINK_ROOT=/home/box/humanink`). Este repo no versiona el binario/script del box — es la fuente de verdad de las **recetas** (`SKILL.md`), no del runtime instalado en el box. Esta carpeta existe para que la ruta relativa mencionada en [`skills/registro-humanink/SKILL.md`](../../registro-humanink/SKILL.md) y en [`GROK-BOT.md`](../../../GROK-BOT.md) sea explícita y navegable dentro del repo.
