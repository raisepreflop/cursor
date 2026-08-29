---
name: informe-de-lectura
description: Use this only when the user explicitly asks for an "informe de lectura" by that exact name on Grok Bot. This skill is deprecated — it performs no reading itself and only points to lector-profesional (dossier section 07) as the current skill to run.
---

# informe-de-lectura (Grok Bot) — DEPRECADO

> **Overlay Grok Bot.** Este skill está deprecado. No leas ni sigas ningún `SKILL.md`/`workflow.md` de Claude Cowork para "informe de lectura" como procedimiento — este archivo es el único puntero válido en Grok Bot, y apunta a `lector-profesional`.

## Qué hace este skill

Nada por sí mismo. Si un usuario o un agente invoca `informe-de-lectura`, este skill:

1. Informa que `informe-de-lectura` está deprecado en este overlay.
2. Redirige explícitamente a `lector-profesional`, aclarando que el veredicto central que antes se llamaba "informe de lectura" ahora vive como la **sección 07 (Veredicto)** del dossier de `lector-profesional`.
3. No ejecuta ninguna lectura, no genera ningún documento, y no llama a `md2docx.py` ni a ningún otro script — su único trabajo es señalar al skill correcto.

## Pasos

1. Detecta la invocación de `informe-de-lectura`.
2. Responde en el chat: "`informe-de-lectura` está deprecado; usa `lector-profesional` — el veredicto que buscas es la sección 07 de su dossier."
3. Si el usuario confirma, continúa directamente con el skill `lector-profesional` (ver `skills/lector-profesional/SKILL.md`) en vez de intentar reproducir el comportamiento antiguo aquí.
