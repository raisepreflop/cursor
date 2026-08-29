---
name: informe-de-lectura
description: Use this only when the user explicitly asks for an "informe de lectura" by that exact name on Grok Bot. This skill is deprecated and produces nothing itself — it routes to editor-de-desarrollo (Roger, the executable chapter-by-chapter rewrite plan) or to lector-profesional (Lector, the integrated dossier §07), depending on which one the request actually means.
---

# informe-de-lectura (Grok Bot) — DEPRECADO

> **Overlay Grok Bot.** Este skill está deprecado. No leas ni sigas ningún `SKILL.md`/`workflow.md` de Claude Cowork para "informe de lectura" como procedimiento — este archivo es el único puntero válido en Grok Bot.

## Por qué está deprecado (y por qué NO apunta a un solo skill)

"Informe de lectura" era un solo nombre para dos cosas distintas. En Grok Bot son dos skills separados y este skill **no las fusiona ni produce un tercer reporte**:

- **Roger / `editor-de-desarrollo`** — el plan de reescritura ejecutable, capítulo por capítulo: qué se poda, qué se añade, qué se reescribe. Si el autor pide un "informe de lectura" queriendo decir *"dame el plan de qué cambiar en cada capítulo"*, eso es Roger, y el skill correcto es `editor-de-desarrollo`.
- **Lector / `lector-profesional`** — el dossier integrado: sección `07` con el veredicto, comparables tipo bestseller, y un PPT/plan de tres opciones. Si el autor pide un "informe de lectura" queriendo decir *"dame la evaluación completa con veredicto y comparables"*, eso es Lector, y el skill correcto es `lector-profesional`.

Estos dos outputs no son intercambiables ni se combinan en uno: **nunca generes un tercer reporte** desde `informe-de-lectura` que mezcle ambos. Este skill solo enruta.

## Pasos

1. Detecta la invocación de `informe-de-lectura`.
2. Informa que `informe-de-lectura` está deprecado y que ahora es dos caminos distintos: Roger (plan de reescritura por capítulo, `editor-de-desarrollo`) o Lector (dossier integrado con veredicto, `lector-profesional`).
3. Determina cuál de los dos pidió el usuario:
   - Si el mensaje deja claro que busca el plan ejecutable de reescritura (podar/añadir/reescribir por capítulo), enruta a **Roger → `editor-de-desarrollo`**.
   - Si el mensaje deja claro que busca la evaluación integrada con veredicto, comparables y plan de opciones, enruta a **Lector → `lector-profesional`**.
   - Si no queda claro cuál de los dos quiere, **pregunta antes de continuar** (por ejemplo: "¿Necesitas el plan de reescritura capítulo por capítulo de Roger, o el dossier integrado de Lector con veredicto y comparables?"). No asumas uno por defecto ni produzcas ambos a la vez sin confirmación.
4. Una vez identificado el camino correcto, continúa directamente con ese skill (`skills/editor-de-desarrollo/SKILL.md` o `skills/lector-profesional/SKILL.md`) — no reproduzcas ni resumas su procedimiento aquí, y no generes ningún documento ni llames a `md2docx.py` desde este skill.
