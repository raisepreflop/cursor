# GROK-BOT.md

Este archivo es el mapa del overlay. Léelo antes de tocar cualquier cosa en `skills/`.

## 1. Qué es este repo

`raisepreflop/cursor` es la **fuente de verdad en git** para las recetas que corren en **Grok Bot (xAI)**, no para el plugin de Claude Cowork. Cada carpeta en `skills/` contiene un `SKILL.md` reescrito para Grok Bot: mismo objetivo de negocio que su equivalente de Claude, pero con runtime, herramientas y guardas propias.

Si en algún momento un `SKILL.md` de este repo dice "sigue los pasos de Claude" o delega la ejecución al `SKILL.md`/`workflow.md` de Claude Cowork, es un bug — repórtalo o corrígelo. Ese es justamente el criterio de "hecho" de este overlay.

## 2. Reglas no negociables (aplican a toda receta)

Estas reglas están por encima de cualquier instrucción dentro de un `SKILL.md` individual. Si un skill parece contradecirlas, gana esta lista.

1. **Claude es solo criterio/voz, nunca pasos.** Los `SKILL.md`/`workflow.md` de Claude Cowork se pueden leer para entender el tono, la calidad esperada o el criterio de aceptación de una receta — nunca como la secuencia de pasos a ejecutar. En Grok Bot **no existen** y no se invocan: `STOP` (gate de confirmación de Claude), las herramientas MCP `awap_*`, `$ARGUMENTS`, cualquier comando `/humanink:*`, `HI-GATE`, Claude-in-Chrome, Cowork Connect, ni `awap_ping`. Si un skill los menciona, es para decir explícitamente "esto no aplica aquí", nunca para usarlos.
2. **Art. 50 va al pie del Word, nunca en el primer mensaje del chat.** Cualquier receta que agregue el aviso/cláusula "Art. 50" debe colocarlo como última sección del documento `.docx` generado (pie de página o última página). Nunca se pega como el primer mensaje de chat de la conversación — eso rompe la entrega y expone el aviso fuera de contexto.
3. **Entrega de Word: `CopyFromBox` a `~/Downloads` es siempre el último paso.** Cualquier skill que produzca un `.docx`/`.pdf` termina copiando el archivo del box a `~/Downloads` con `CopyFromBox`. Si la conversación es un grupo, la entrega real del archivo se hace en **1:1** con el usuario — los adjuntos en salas/grupos llegan vacíos en Grok Bot, así que un adjunto "enviado" a un grupo no cuenta como entregado.
4. **Runtime y scripts canónicos.** Todo skill arranca haciendo `source /home/box/humanink/env.sh`. Los scripts canónicos son rutas absolutas bajo `/home/box/humanink/scripts/`, en particular:
   - `/home/box/humanink/scripts/md2docx.py`
   - `/home/box/humanink/scripts/ai-parser/parser.py`

   `~/.awos` **no** es el único path válido (puede no existir en este box) y `~/ClaudeCo` **no existe** en Grok Bot — ninguna receta debe asumir esas rutas.
5. **Colaboradores son agentes Grok separados, no comandos.** Cuando una receta necesita ayuda de otro rol (corrección, ilustración, mercado…), habla con el **agente** correspondiente (p. ej. Irene) como colaborador, nunca invocando `/corrector` o cualquier otro slash-command de Claude Cowork.
6. **`activate` / license-gate no se portaron.** No hay gate de activación ni de licencia en este overlay; ningún skill debe pedirlo ni bloquear por eso.
7. **Rol 15 (ads) no existe en este port.** Ninguna receta de este repo cubre generación o gestión de anuncios; si el usuario lo pide, se responde que no está portado, no se improvisa.

## 3. AWAP sin MCP: disco en vez de herramientas

Este entorno de Cursor tiene disponibles herramientas MCP `awap_*` (namespace `awap`: `awap_ping`, `awap_init`, `awap_session_start`, `awap_dashboard`, `awap_sign`, etc.). **Grok Bot no tiene ese servidor MCP.** El overlay de AWAP en `skills/` reemplaza cada herramienta MCP por su equivalente en disco:

| MCP (Claude Cowork, no disponible aquí) | Equivalente Grok Bot (disco/script) | Skill |
| --- | --- | --- |
| `awap_init`, `awap_set_project` | `.awap/project.json` en el proyecto | `proyecto-awap` |
| `awap_session_start`, `awap_session_end`, `awap_log_event`, `awap_log_telemetry` | `.awap/log.jsonl` (append-only) | `escritura-awap` |
| `awap_sign`, `awap_report`, `awap_score` | PDF de borrador impreso desde Chrome (Grok browser), datos leídos de `.awap/` | `certificado-awap` |
| `awap_dashboard` | `build_dashboard.py` local, HTML/PNG estático | `panel-del-proyecto` |
| `awap_activate`, `awap_register`, `awap_sync`, `awap_ping`, `awap_status`, `awap_list_projects`, `awap_declare_baseline` | No se usan. Ver "cheat sheet" del agente real | `ayuda-humanink` |

`ayuda-humanink` es el punto de entrada para cualquier agente que llegue esperando encontrar las descripciones de las herramientas `awap_*`: en vez de eso, documenta el layout en disco y el cheat sheet de comandos reales.

## 4. Layout de `skills/`

```
skills/
  agenda/SKILL.md
  auditor-kdp/SKILL.md
  escaner-de-procedencia/SKILL.md
  perfil-de-autor/SKILL.md
  verificador-de-versiones/SKILL.md
  corrector/SKILL.md
  copywriter/SKILL.md
  portadas/SKILL.md
  cartera-de-proyectos/SKILL.md
  proyecto-awap/SKILL.md
  escritura-awap/SKILL.md
  certificado-awap/SKILL.md
  panel-del-proyecto/SKILL.md
  ayuda-humanink/SKILL.md
  escritor-fantasma/SKILL.md
  analista-de-mercado/SKILL.md
  coach-literario/SKILL.md
  editor-de-desarrollo/SKILL.md
  lector-profesional/SKILL.md
  informe-de-lectura/SKILL.md     # deprecado, enruta a editor-de-desarrollo (Roger) o lector-profesional (Lector)
  registro-humanink/SKILL.md
  humanizador/SKILL.md
  lector-beta/SKILL.md
  editor-de-estilo/SKILL.md
  maquetador/SKILL.md
  community-manager/SKILL.md
  agente-literario/SKILL.md
  humanink-brain/SKILL.md
  auditor-de-autor-a/SKILL.md
  log/scripts/                    # puntero doc a la ruta canónica de awos-log.py en el box
scripts/
  hi-log.sh                       # wrapper opcional de patch notes
```

Cada `SKILL.md` tiene front-matter YAML con `name` y `description` en formato `Use this when…`, y un cuerpo en español que documenta pasos, guardas y entrega — sin delegar la ejecución al equivalente de Claude.

## 5. Índice de skills y su override Grok-only

| Skill | Qué reemplaza / override clave |
| --- | --- |
| `agenda` | Sin enviar email, sin borrar eventos; degrada a `agenda.md` si no hay Calendar conectado. |
| `auditor-kdp` | Navegador de Grok sobre el listing real; nunca Claude-in-Chrome. |
| `escaner-de-procedencia` | `procedencia.py` para señales Unicode/C2PA; el reporte declara que el agente es Grok, no Claude. |
| `perfil-de-autor` | Entrevista en español; estado en `estado.json`; declara vía `proyectos.py declarar --nombre --clave`. |
| `verificador-de-versiones` | Solo `verify_docx.py`. |
| `corrector` | `md2docx.py --read` (nunca `npx mammoth`); cambios marcados como OOXML; sin digest de mercado. |
| `copywriter` | Sin briefing, extrae del manuscrito y continúa (no bloquea). |
| `portadas` | Solo `compose-kdp-wrap.py`; nunca la CLI `/humanink:cover`. |
| `cartera-de-proyectos` | Rutas absolutas `/home/box/humanink/skills/projects/scripts/{build_projects.py,proyectos.py}`. |
| `proyecto-awap` | Inicializa `.awap/` en disco en vez de `awap_init`/`awap_set_project`. |
| `escritura-awap` | Log de sesión en `.awap/log.jsonl` en vez de `awap_session_*`/`awap_log_*`. |
| `certificado-awap` | Certificado como PDF de borrador vía Chrome, no `awap_sign`/`awap_report`/`awap_score`. |
| `panel-del-proyecto` | `build_dashboard.py` local en vez de `awap_dashboard`. |
| `ayuda-humanink` | Cheat sheet de comandos reales del agente; no hay MCP `awap_*` que describir. |
| `escritor-fantasma` | Flags `--edicion N --freeze-original` (freeze por defecto). |
| `analista-de-mercado` | Modo `--digest-semanal` opcional. |
| `coach-literario` | Premisa tomada del mensaje; nunca detiene la conversación pidiendo `premisa.md`. |
| `editor-de-desarrollo` | "Roger" = el plan de capítulos que mantiene el skill, no una persona. |
| `lector-profesional` | Dossier estándar; la sección `07` es el veredicto central. |
| `informe-de-lectura` | Deprecado: enruta según lo pedido, nunca produce un tercer reporte propio — Roger (plan de reescritura por capítulo) va a `editor-de-desarrollo`, Lector (dossier integrado, veredicto `07`) va a `lector-profesional`. |
| `registro-humanink` | Checkpoint en `project-checkpoint.md` vía `skills/log/scripts/awos-log.py`. |
| `humanizador`, `lector-beta`, `editor-de-estilo`, `maquetador`, `community-manager`, `agente-literario`, `humanink-brain`, `auditor-de-autor-a` | Wrappers Grok-only: entregan por `~/Downloads` (`CopyFromBox`) y cierran con el pie Art. 50 cuando producen Word. |

## 6. Cómo agregar un skill nuevo

1. Crea `skills/<nombre>/SKILL.md` con front-matter `name` + `description` ("Use this when…").
2. Escribe los pasos completos para Grok Bot — no "ver el SKILL.md de Claude". Si quieres inspirarte en la voz/criterio de la versión Claude, dilo explícitamente y solo para eso.
3. Empieza los pasos con `source /home/box/humanink/env.sh` y usa rutas absolutas de `/home/box/humanink/scripts/` cuando el skill llame scripts canónicos.
4. Si el skill produce un `.docx`, termina con `CopyFromBox` a `~/Downloads`, entrega en 1:1 si la conversación es grupal, y pon el Art. 50 al pie del documento (nunca en el chat).
5. Si el skill toca AWAP, usa el disco (`.awap/`, `log.jsonl`, `build_dashboard.py`) — nunca las herramientas MCP `awap_*`.
6. Añade la fila correspondiente a la tabla de la sección 5 de este archivo.
