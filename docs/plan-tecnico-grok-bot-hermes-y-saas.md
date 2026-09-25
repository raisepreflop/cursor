# Plan técnico — Skin de Grok Bot sobre Hermes + Dashboard SaaS con Stripe

> Contexto: este documento no forma parte del overlay de skills de Grok Bot para HumanInk (ver [`GROK-BOT.md`](../GROK-BOT.md)). Es un plan técnico independiente, entregado en este repo porque es donde se pidió, para dos iniciativas distintas sobre el proyecto **Hermes Agent** (`NousResearch/hermes-agent`).

## 0. Resumen ejecutivo

Dos pistas de trabajo, en paralelo, sin dependencia mutua:

1. **Skin visual "Grok Bot" sobre el dashboard web de Hermes** — solo CSS + un plugin de tema, sin fork.
2. **Dashboard SaaS de cliente con Stripe** — producto propio (Next.js + backend propio) que llama al API server de Hermes como motor de agente, con billing, entitlements y aislamiento multi-tenant.

Antes de detallar cada parte, hay **tres correcciones al brief original** que cambian decisiones de arquitectura de forma material. Las encontré verificando la documentación oficial de Hermes y el propio código fuente (`NousResearch/hermes-agent` en GitHub, MIT license), no asumiendo lo que el brief describía:

### Corrección 1 — Hermes tiene *tres* sistemas de personalización, no uno, y son incompatibles entre sí

| Sistema | Dónde vive | SDK / mecanismo | Quién lo usa |
|---|---|---|---|
| **CLI skins** | `~/.hermes/skins/*.yaml` | `skin_engine.py`, solo afecta banner/spinner/colores de terminal | `hermes` en modo texto |
| **Desktop app plugins** | `~/.hermes/desktop-plugins/` | `@hermes/plugin-sdk`, un único archivo ESM, sin build | La app de escritorio (`hermes desktop`) |
| **Web dashboard themes + plugins** | `~/.hermes/dashboard-themes/*.yaml` y `~/.hermes/plugins/*/dashboard/` | `window.__HERMES_PLUGIN_SDK__`, YAML de tema + `manifest.json` + bundle IIFE pre-compilado | `hermes dashboard` (FastAPI + React, puerto 9119) — **este es tu objetivo** |

Los dos repos comunitarios que menciona el brief — `guidsen/hermes-grok-bot-skin` y `thomasbek3/hermes-bot-kit` — **son plugins de la Desktop app** (se instalan en `~/.hermes/desktop-plugins/`, usan `@hermes/plugin-sdk`), no del web dashboard que corre en el puerto 9119 con `web/src`, Vite y FastAPI. Son una **referencia visual excelente** (burbujas iMessage, puntos verde/ámbar, avatares compactos — literalmente el mismo objetivo visual) pero **su código no es portable directamente**: hay que reimplementar el mismo criterio visual contra el SDK del dashboard web (`window.__HERMES_PLUGIN_SDK__` + `manifest.json`), que expone una API distinta (componentes shadcn ya instanciados, slots con nombre, temas YAML declarativos) en vez del ESM libre de la Desktop app.

Acción: tratar esos dos repos como **moodboard/spec de producto**, no como fuente de partida de código.

### Corrección 2 — El dashboard web ya trae un motor de temas y plugins en caliente; no hace falta tocar `web/` para nada del skin

La documentación oficial ("Extending the Dashboard") es explícita: *"no repo clone, no `npm run build`, no patching the dashboard source"*. Un tema es un YAML en `~/.hermes/dashboard-themes/`; un plugin es una carpeta con `manifest.json` + un bundle JS (IIFE) en `~/.hermes/plugins/<nombre>/dashboard/`. Ambos se descubren en caliente (`GET /api/dashboard/themes`, `GET /api/dashboard/plugins`, y `GET /api/dashboard/plugins/rescan` para forzar recarga sin reiniciar).

Esto significa que **clonar el repo de Hermes, hacer `pip install -e "."` y correr `npm run dev` en `web/` no es un requisito técnico para construir el skin** — es opcional, y solo aporta valor si:
- quieres inspeccionar el DOM real del dashboard en modo dev (sourcemaps, mejor devtools) mientras diseñas el CSS del plugin, o
- necesitas tocar algo que sí vive en el core (ver el único caso legítimo en la sección 1.6 — el catálogo de iconos Lucide).

Lo que sí genera `npm run build` en `hermes_cli/web_dist/` es el **shell del dashboard en sí** (la SPA de React que sirve FastAPI) — irrelevante para un skin que se instala como plugin/tema externo, salvo que decidieras (no recomendado) meter el skin como plugin "bundled" dentro del propio paquete de Hermes.

Mantengo ambos flujos en el plan (sección 1.4) porque el segundo sigue siendo útil para iterar con comodidad, pero el flujo recomendado por defecto es el ligero (sin clonar nada).

### Corrección 3 — El "profile por tenant" de Hermes no expone automáticamente un API server por tenant; hay que decidir la topología de aislamiento explícitamente

Cada perfil de Hermes (`~/.hermes/profiles/<tenant>/`) corre **su propio proceso de gateway**, con su propio `.env`, su propio `API_SERVER_KEY` y, si el API server está activo, su propio puerto (por defecto `8642` para todos — colisiona si corres N tenants a la vez sin reasignar puertos). Existe una alternativa — un *gateway multiplexado* (`gateway.multiplex_profiles: true`) que sirve todos los perfiles desde un solo proceso vía `/p/{profile}/v1/...` — pero la propia documentación de Hermes reporta un **bug de seguridad conocido en ese modo**: los endpoints de estado/parada/aprobación de un *run* (`/v1/runs/{run_id}/...`) autentican la clave del llamador pero **no verifican que el `run_id` pertenezca a ese perfil** — cualquier tenant con su propia `API_SERVER_KEY` válida puede leer o controlar el *run* de otro tenant si conoce (o adivina/enumera) su `run_id`. Este hallazgo cambia la recomendación de aislamiento del plan (ver sección 2.2).

Con esto aclarado, el plan detallado:

---

## 1. Parte uno — Skin de Grok Bot sobre el dashboard web de Hermes

### 1.1 Objetivo

Reskin visual completo del dashboard web de Hermes (paleta, radios, tipografía, burbujas de chat estilo iMessage, sidebar de bots con avatares geométricos y puntos de estado verde/ámbar), activable desde **Settings → Appearance**, sin fork del core y sin build propio de Hermes.

### 1.2 Arquitectura elegida: tema YAML + plugin "slot-only"

Dos piezas independientes, cada una en su propio archivo, empaquetadas juntas en un repo propio (`grok-bot-hermes-skin`):

**A. Tema (`grok-skin.yaml`)** — cubre todo lo que es *paleta derivada + tipografía + layout + CSS declarativo*:
- `palette` (3 capas: `background` / `midground` / `foreground`) → de aquí se derivan automáticamente vía `color-mix()` todos los tokens shadcn (`card`, `popover`, `muted`, `border`, `primary`, `ring`, etc.), así que la mayor parte de "cambia los tokens de color" se resuelve con 2-3 colores, no con un CSS gigante.
- `layout.radius` → controla `--radius` y en cascada `--radius-sm/md/lg/xl` (bordes redondeados app-wide).
- `layout.density` → compacto/cómodo/espacioso.
- `componentStyles` (buckets `card`, `header`, `footer`, `sidebar`, `tab`, `progress`, `badge`, `backdrop`, `page`) → chrome de componentes sin escribir selectores CSS.
- `colorOverrides` → afinar acentos puntuales que la derivación automática no produce (verde de estado "trabajando", ámbar de "esperando").
- `customCSS` (cap de 32 KiB por tema) → para lo que no cubre lo anterior: forma de burbuja (`border-radius` asimétrico + "cola" con `clip-path` o pseudo-elemento), remate final del look iMessage.

**B. Plugin "slot-only" (`grok-bots-hud`)** — cubre lo que es *comportamiento/DOM dinámico*, no CSS puro:
- Avatares geométricos generados (SVG determinista a partir del nombre/id del bot — mismo enfoque que un "identicon"), inyectados donde el theming declarativo no llega.
- Punto de estado verde/ámbar reactivo al estado real del bot, leído vía `SDK.api.getStatus()` o polling del endpoint de sesiones — no un simple `::after` estático, sino un componente React montado en un slot.
- Manifest con `"tab": {"hidden": true}` — este plugin no añade una pestaña nueva a la navegación, solo registra CSS/HUD dentro de slots existentes.

Slots disponibles que importan para este objetivo (documentado en "Extending the Dashboard"): `sidebar` (solo se renderiza si el tema activa `layoutVariant: cockpit`), `sessions:top/bottom`, `header-left`, `header-right`, `overlay`. Para el objetivo de "sidebar de bots", el primer paso de descubrimiento (1.3) debe confirmar si el dashboard *web* ya tiene una vista de "Bots" equivalente a la de Bot Mode (que en la documentación aparece descrita para la **Desktop app**, no explícitamente para el dashboard web) — si no existe nativamente, el plugin construirá esa vista sobre la lista de `/sessions` vía slots (`sessions:top`) y/o `tab.override` si hace falta reemplazar la página completa.

### 1.3 Fase 0 — Descubrimiento (spike, antes de escribir una sola línea de CSS)

Este paso es obligatorio y no está en el brief original, pero sin él el resto del plan es especulativo:

1. `pip install 'hermes-agent[web,pty]'` (instalación normal, sin clonar) → `hermes dashboard --no-open --port 9119`.
2. Abrir el dashboard, `hermes profile create bot-demo` + `hermes profile create bot-demo-2` para tener contenido real en el selector de perfiles/sesiones.
3. Con devtools abiertas, inspeccionar:
   - ¿Existe una pestaña "Bots" nativa en el dashboard web, o el concepto de "bot" ahí es simplemente "perfil" listado en el selector? Esto decide si el plugin necesita `tab.override` sobre una ruta existente o solo slots.
   - Clases reales (Tailwind v4 utilitarias) que renderizan una fila de sesión/mensaje — para escribir selectores CSS estables en `customCSS` en vez de adivinar.
   - Confirmar `GET /api/dashboard/themes` y `GET /api/dashboard/plugins` responden como documentado en esta instancia (verificar versión de Hermes instalada vs. la de la documentación consultada — la doc citada corresponde a una build reciente de 2026; conviene fijar un rango de versión soportado).
4. Documentar hallazgos en `SPIKE.md` dentro del repo del skin antes de pasar a implementación — esto es lo que reemplaza, en este plan, a la suposición "ya existe la base" del brief.

### 1.4 Bucle de desarrollo local — dos variantes válidas

**Variante ligera (recomendada por defecto):**
```bash
pip install 'hermes-agent[web,pty]'
hermes dashboard --no-open --port 9119
# en otra terminal, dentro del repo del skin:
npx esbuild src/plugin.tsx --bundle --format=iife \
  --external:react --outfile="$HOME/.hermes/plugins/grok-bots-hud/dashboard/dist/index.js" \
  --watch
cp theme/grok-skin.yaml ~/.hermes/dashboard-themes/
curl http://127.0.0.1:9119/api/dashboard/plugins/rescan
# refrescar el navegador tras cada rebuild (el bundle del plugin se carga por <script>, no HMR)
```
No requiere clonar `hermes-agent`. `React` se marca `external` porque el SDK lo expone en `SDK.React` — nunca se empaqueta React propio (así lo exige la documentación, y evita duplicados de versión).

**Variante pesada (según describe el brief — útil si ya necesitas el repo por otro motivo, o para depurar el *shell* del dashboard con sourcemaps):**
```bash
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent && uv pip install -e ".[web,pty]"
hermes dashboard --no-open --port 9119   # backend FastAPI
cd web && npm install && npm run dev     # Vite dev server, proxy /api -> :9119
```
Los archivos del skin (tema YAML + plugin) se siguen instalando en `~/.hermes/`, exactamente igual — clonar el repo solo cambia cómo ves el *shell*, no cómo se distribuye el skin. `npm run build` → `hermes_cli/web_dist/` solo importa si se toca el core (sección 1.6); no forma parte del flujo de entrega del skin.

### 1.5 Estructura de repo propuesta (`grok-bot-hermes-skin`)

```
grok-bot-hermes-skin/
├── theme/
│   └── grok-skin.yaml            # tema declarativo (paleta, radios, componentStyles, customCSS)
├── plugin/
│   ├── manifest.json             # tab.hidden=true, slots: ["sidebar","sessions:top","header-left"]
│   ├── src/
│   │   ├── plugin.tsx            # entrypoint, registra vía SDK
│   │   ├── avatar.tsx            # generador de avatar geométrico (SVG determinista)
│   │   └── status-dot.tsx        # punto verde/ámbar reactivo
│   └── dist/
│       └── index.js              # bundle IIFE generado (gitignored o commiteado, a decidir)
├── install.sh                    # curl | bash — copia theme/ y plugin/ a ~/.hermes/
├── SPIKE.md                      # hallazgos de la fase 0
└── README.md
```

Ejemplo de `manifest.json`:
```json
{
  "name": "grok-bots-hud",
  "label": "Grok Bots HUD",
  "icon": "Sparkles",
  "version": "0.1.0",
  "tab": { "path": "/grok-bots-hud", "hidden": true },
  "slots": ["sidebar", "sessions:top", "header-left"],
  "entry": "dist/index.js",
  "css": "dist/style.css"
}
```

Esqueleto de `plugin.tsx` (IIFE, sin bundler de React):
```javascript
(function () {
  "use strict";
  const SDK = window.__HERMES_PLUGIN_SDK__;
  const { React } = SDK;
  const { useEffect, useState } = SDK.hooks;

  function StatusDot({ botId }) {
    const [state, setState] = useState("idle"); // idle | working | waiting
    useEffect(() => {
      let cancelled = false;
      async function poll() {
        const status = await SDK.api.getStatus();
        if (!cancelled) setState(mapStatus(status, botId));
      }
      poll();
      const id = setInterval(poll, 4000);
      return () => { cancelled = true; clearInterval(id); };
    }, [botId]);
    const color = state === "working" ? "#22c55e" : state === "waiting" ? "#f59e0b" : "transparent";
    return React.createElement("span", {
      className: "grok-status-dot",
      style: { background: color },
    });
  }

  function Placeholder() { return null; } // requerido: registrar el componente principal aunque el tab esté oculto
  window.__HERMES_PLUGINS__.register("grok-bots-hud", Placeholder);
  window.__HERMES_PLUGINS__.registerSlot("grok-bots-hud", "sidebar", BotsSidebar);
})();
```

Ejemplo de `theme/grok-skin.yaml` (fragmento representativo, no exhaustivo):
```yaml
name: grok-skin
label: Grok Bot
description: Skin estilo Grok Bot — burbujas iMessage, sidebar de bots, acentos verde/ámbar

palette:
  background: { hex: "#0b0f14", alpha: 1.0 }
  midground: "#e8edf2"
  foreground: { hex: "#ffffff", alpha: 0.0 }
  noiseOpacity: 0.3

typography:
  fontSans: "-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
  baseSize: "14px"

layout:
  radius: "1.1rem"       # burbujas/tarjetas muy redondeadas
  density: comfortable

colorOverrides:
  primary: "#0a84ff"      # azul iMessage para "mis" mensajes
  success: "#22c55e"      # punto verde — bot trabajando
  warning: "#f59e0b"      # punto ámbar — bot esperando

customCSS: |
  /* Selectores confirmados en la fase 0 (SPIKE.md) contra la build real */
  [data-role="chat-bubble"][data-mine="true"] {
    background: var(--color-primary);
    color: white;
    border-radius: 18px 18px 4px 18px;
  }
  [data-role="chat-bubble"][data-mine="false"] {
    background: var(--color-muted);
    border-radius: 18px 18px 18px 4px;
  }
  .grok-status-dot {
    position: absolute; width: 10px; height: 10px; border-radius: 999px;
    bottom: -1px; right: -1px; border: 2px solid var(--color-background);
  }
```

> Nota: los selectores `[data-role="chat-bubble"]` de arriba son **ilustrativos**. Deben reemplazarse por los selectores reales que salgan de la fase 0 (1.3), porque el dashboard puede usar clases utilitarias de Tailwind directamente en vez de atributos `data-*` semánticos — es exactamente el tipo de dato que no se puede inventar sin correr el dashboard real.

### 1.6 El único caso legítimo de "tocar el core"

El catálogo de iconos Lucide del plugin manifest está reducido a una lista fija (`Activity, BarChart3, Clock, Code, Database, Eye, FileText, Globe, Heart, KeyRound, MessageSquare, Package, Puzzle, Settings, Shield, Sparkles, Star, Terminal, Wrench, Zap`); cualquier nombre fuera de esa lista cae a `Puzzle`. Si ningún icono de la lista transmite bien "Grok"/bot, hay dos caminos:
- usar `Sparkles` o `Zap` (aceptable, cero riesgo, cero PR upstream), o
- abrir un PR aditivo a `web/src/App.tsx` (`ICON_MAP`) en el repo de Hermes — la documentación lo señala explícitamente como el único punto de extensión que requiere tocar código del core, y es un cambio puramente aditivo (no reescribe nada existente).

Recomendación: usar `Sparkles` para el MVP y no bloquear la entrega en un PR upstream de terceros.

### 1.7 Activación desde Settings → Appearance

No requiere código propio: es el comportamiento nativo del selector de temas del dashboard (icono de paleta en el header → lista temas via `GET /api/dashboard/themes`, incluye automáticamente cualquier YAML en `~/.hermes/dashboard-themes/`). El plugin se activa siempre que esté en `~/.hermes/plugins/` y el dashboard lo detecte (no requiere un toggle explícito salvo que el usuario deshabilite plugins individualmente desde la configuración de Hermes). La única atadura entre "elegir el tema Grok Bot" y "activar el HUD del plugin" es de diseño, no de plataforma — si se quiere que el HUD solo aparezca con el tema Grok activo, condicionar el registro del slot `sidebar` a `layoutVariant: cockpit` (que el tema Grok activa) es el mecanismo nativo ya provisto por Hermes para ese acoplamiento.

### 1.8 Pruebas y checklist de aceptación

- [ ] `curl http://127.0.0.1:9119/api/dashboard/themes` incluye `grok-skin`.
- [ ] `curl http://127.0.0.1:9119/api/dashboard/plugins` incluye `grok-bots-hud` sin errores de parseo de manifest.
- [ ] Consola del navegador sin errores tras cargar el tema + plugin (404 de `index.js`/`style.css`, `window.__HERMES_PLUGINS__ is undefined`, excepciones en el IIFE).
- [ ] `customCSS` del tema pesa menos de 32 KiB (`wc -c theme/grok-skin.yaml` como proxy rápido).
- [ ] Cambiar de tema y volver a Grok Skin no dejar `colorOverrides` residuales de otro tema (comportamiento nativo, pero verificar).
- [ ] El HUD de sidebar respeta el guard de `layoutVariant: cockpit` — no debe romper otros temas si el usuario cambia de skin.
- [ ] Probar en una instalación limpia (`pip install`, sin clonar) siguiendo únicamente `install.sh`, para validar que "no toca el core" es cierto de punta a punta.

### 1.9 Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Selectores CSS de `customCSS` se rompen en un `hermes update` si cambian las clases utilitarias del shell | Fijar un rango de versión soportado del dashboard en el `README`; añadir un smoke test manual post-`hermes update` que compare capturas de la vista de sesiones. |
| El dashboard web no tiene vista "Bots" nativa (solo la Desktop app la tiene) | Cubierto por la fase 0 — si no existe, el plugin construye ese HUD sobre `/sessions` con slots, en vez de asumir una pestaña que no está ahí. |
| `tab.override` en conflicto con otro plugin que reclame la misma ruta | Documentado por Hermes: "el primero gana, el segundo se ignora con warning" — evitar `override` salvo que sea estrictamente necesario; preferir slots. |
| Plugin/tema quedan huérfanos al desinstalar Hermes o cambiar de perfil | Son archivos de usuario en `~/.hermes/`, no dependen del perfil activo (viven a nivel de instalación, no de `HERMES_HOME` de un perfil concreto) — documentar esto en el README para evitar confusión. |

### 1.10 Orden de trabajo (Parte 1)

1. Fase 0 — descubrimiento contra un dashboard real, documentar en `SPIKE.md`.
2. Tema YAML (paleta, radios, `colorOverrides`) — iteración visual rápida, sin JS.
3. `customCSS` para burbujas de chat con los selectores confirmados en la fase 0.
4. Plugin slot-only: avatar geométrico + punto de estado (empezar por un dato mockeado, luego conectar a `SDK.api.getStatus()`).
5. `install.sh` + README de instalación de un comando.
6. Checklist de la sección 1.8 en una instalación limpia.

---

## 2. Parte dos — Dashboard SaaS de cliente con Stripe

### 2.1 Arquitectura general

```
┌─────────────────────┐      ┌──────────────────────┐      ┌───────────────────────────┐
│  Dashboard cliente   │ HTTPS│  Backend propio (API) │ HTTP │  Hermes (por tenant)      │
│  Next.js 15 + shadcn ├─────►│  FastAPI/NestJS       ├─────►│  API server OpenAI-compat │
│  (visual == skin de  │      │  PostgreSQL + Prisma  │      │  puerto 8642 interno      │
│   Hermes, sección 1) │      │  Redis (rate limit,   │      │  API_SERVER_KEY por       │
└─────────────────────┘      │  colas, entitlements) │      │  tenant                   │
                              └──────────┬────────────┘      └───────────────────────────┘
                                         │
                                         ▼
                                 ┌───────────────┐
                                 │ Stripe Billing │
                                 │ (suscripción + │
                                 │  metered usage)│
                                 └───────────────┘
```

El dashboard de cliente **nunca** habla directo con Hermes ni conoce `API_SERVER_KEY` de ningún tenant — todo pasa por tu backend, que es el único que guarda esas claves (cifradas en reposo) y decide, por entitlement, si la llamada procede antes de reenviarla a Hermes.

### 2.2 Hallazgo crítico y decisión de aislamiento multi-tenant

Verificado contra la documentación oficial de Hermes (sección 0, Corrección 3): existen dos topologías soportadas para servir múltiples perfiles, con trade-offs muy distintos para un SaaS de facturación:

**Opción A — Un proceso de gateway por tenant (recomendada para el MVP y para el estado estable).**
- Cada tenant = su propio `hermes profile create <tenant>` + su propio proceso `<tenant> gateway start` con `API_SERVER_ENABLED=true` y un `API_SERVER_KEY` único generado por tu backend al aprovisionar.
- Aislamiento de proceso real: memoria, sesiones, credenciales, y (importante para billing) límites de recursos por proceso/contenedor son un boundary del SO, no solo de aplicación.
- Contención de un tenant problemático (fuga de créditos, abuso, bug) = matar un proceso/contenedor, cero impacto en los demás.
- Coste operativo: un proceso (o contenedor) vivo por tenant activo. Mitigable con arranque/parada bajo demanda (cold start al primer request tras inactividad, apagado tras N minutos idle) gestionado por tu propio control-plane.
- Puertos: no publicar `8642` al host. Cada contenedor de tenant vive en una red Docker/K8s interna (`hermes-tenant-<id>`); tu backend llama por nombre de servicio interno (`http://hermes-tenant-<id>:8642/v1/...`), nunca expuesto a internet.

**Opción B — Gateway multiplexado (`gateway.multiplex_profiles: true`), un solo proceso sirve todos los tenants vía `/p/{profile}/v1/...`.**
- Mucho más barato operativamente (un proceso para N tenants).
- **Riesgo de seguridad documentado y reproducido por el propio proyecto** (issue conocido, versión reportada 0.20.4): los endpoints de estado/parada/aprobación de un *run* (`/v1/runs/{run_id}/status`, `/stop`, `/steer`, `/approval`) validan que la `API_SERVER_KEY` del llamador sea *de algún perfil servido*, pero no verifican que el `run_id` pertenezca a *ese* perfil concreto — un tenant que conozca o enumere el `run_id` de otro puede leer o intervenir su ejecución.
- Además, según la propia documentación, el nombre de la config key ha tenido inconsistencias entre versiones (`multiplex_profiles` vs `multiplex_profile_allowlist`) — riesgo de que el flag no surta efecto silenciosamente si se fija mal.

**Decisión para este plan: Opción A (proceso/contenedor por tenant) para el lanzamiento**, precisamente por el bug de aislamiento cross-tenant de la Opción B, que es inaceptable en un producto de pago con créditos y datos de cliente. Revisar la Opción B solo si (a) el issue de aislamiento por `run_id` está confirmado corregido en la versión de Hermes en uso, y (b) la escala de tenants activos concurrentes hace prohibitivo un proceso por tenant — decisión de costo vs. riesgo a tomar más adelante con datos reales, no ahora.

Consecuencia de diseño: tu backend necesita una tabla `hermes_instances` (o similar) que trackee, por tenant: contenedor/proceso vivo o no, puerto/hostname interno, `api_server_key` (cifrada), última actividad (para apagar por inactividad), y estado de salud (`GET /health` sin auth).

### 2.3 Orden de trabajo (siguiendo el orden pedido: backend+Stripe primero, luego frontend, luego Hermes)

#### Fase 1 — Backend con Stripe y entitlements

**Modelo de datos (Prisma, fragmento representativo):**
```prisma
model Organization {
  id                String        @id @default(cuid())
  name              String
  stripeCustomerId  String?       @unique
  createdAt         DateTime      @default(now())
  subscriptions     Subscription[]
  entitlement       Entitlement?
  hermesInstance    HermesInstance?
  users             User[]
  apiCallLogs       ApiCallLog[]
}

model Subscription {
  id                    String   @id @default(cuid())
  organizationId        String
  organization          Organization @relation(fields: [organizationId], references: [id])
  stripeSubscriptionId  String   @unique
  stripePriceId         String
  status                String   // active, past_due, canceled, incomplete...
  currentPeriodEnd      DateTime
  planKey               String   // "starter" | "pro" | "scale"
  updatedAt             DateTime @updatedAt
}

// Capa de entitlements propia: NUNCA se consulta a Stripe en cada request.
// Se actualiza únicamente desde los webhooks (fuente de verdad local).
model Entitlement {
  id               String   @id @default(cuid())
  organizationId   String   @unique
  organization     Organization @relation(fields: [organizationId], references: [id])
  planKey          String   // referencia a un catálogo de planes en código, no en DB
  features         Json     // { "maxSkills": 10, "canUseVoice": true, ... }
  creditsIncluded  Int      // créditos incluidos por ciclo
  creditsUsed      Int      @default(0)
  creditsResetAt   DateTime
  status           String   // "active" | "suspended" | "past_due_grace"
  updatedAt        DateTime @updatedAt
}

model StripeWebhookEvent {
  id          String   @id            // event.id de Stripe — clave de idempotencia
  type        String
  receivedAt  DateTime @default(now())
  processedAt DateTime?
  payload     Json
}

model HermesInstance {
  id               String   @id @default(cuid())
  organizationId   String   @unique
  organization     Organization @relation(fields: [organizationId], references: [id])
  containerName    String   @unique   // "hermes-tenant-<orgId>"
  internalHost     String             // DNS interno del contenedor
  apiServerKeyEnc  String             // cifrado con KMS/libsodium, nunca en claro
  status           String             // "provisioning" | "running" | "stopped" | "error"
  lastActiveAt     DateTime?
}

model ApiCallLog {
  id             String   @id @default(cuid())
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  endpoint       String
  creditsCharged Int
  createdAt      DateTime @default(now())
}
```

**Idempotencia de webhooks (patrón obligatorio):**
```python
@router.post("/webhooks/stripe")
async def stripe_webhook(request: Request):
    payload = await request.body()
    sig = request.headers["stripe-signature"]
    event = stripe.Webhook.construct_event(payload, sig, STRIPE_WEBHOOK_SECRET)

    # Idempotencia por event.id: insertar antes de procesar, con UNIQUE constraint.
    inserted = await db.stripe_webhook_event.create_if_not_exists(
        id=event["id"], type=event["type"], payload=event
    )
    if not inserted:
        return {"received": True, "duplicate": True}  # ya procesado, no repetir efectos

    match event["type"]:
        case "customer.subscription.updated":
            await sync_entitlement_from_subscription(event["data"]["object"])
        case "invoice.payment_succeeded":
            await handle_payment_succeeded(event["data"]["object"])
        case "invoice.payment_failed":
            await handle_payment_failed(event["data"]["object"])
        case "customer.subscription.deleted":
            await suspend_entitlement(event["data"]["object"])
        case _:
            pass  # eventos no relevantes, se registran igual para auditoría

    await db.stripe_webhook_event.mark_processed(event["id"])
    return {"received": True}
```

Eventos mínimos obligatorios (los tres del brief) más dos adicionales recomendados por robustez:
- `customer.subscription.updated` — recalcula `Entitlement.features`/`creditsIncluded`/`planKey` a partir del `price.id` de la suscripción (mapeo plan→features vive en código, versionado, no en Stripe).
- `invoice.payment_succeeded` — resetea `creditsUsed` a 0 al inicio del nuevo periodo (`creditsResetAt`).
- `invoice.payment_failed` — mueve `Entitlement.status` a `past_due_grace` (no corta acceso inmediatamente; define una ventana de gracia de N días antes de `suspended`).
- `customer.subscription.deleted` — `status = "suspended"`, apaga/pausa el `HermesInstance` del tenant tras un margen de retención de datos.
- `checkout.session.completed` — para el alta inicial (crear `Organization`/`Entitlement`/`HermesInstance` la primera vez, antes de que llegue el primer `subscription.updated`).

**Metered billing por llamadas a la API:** usar el API de "Billing Meters" de Stripe (meter events asociados a un `price` con `recurring.usage_type: metered`) en vez del legado `usage_records` — verificar el nombre exacto de los endpoints contra la documentación de Stripe en el momento de implementar, dado que Stripe ha evolucionado esta área varias veces; el patrón de diseño no cambia: cada llamada exitosa al API server de Hermes reenviada a través de tu backend incrementa `Entitlement.creditsUsed` de forma local e inmediata (para poder bloquear en tiempo real sin esperar a Stripe) **y** emite un evento de medición a Stripe de forma asíncrona (cola en Redis) para que la factura reflec­te el consumo real — la contabilidad de negocio vive en Stripe, el *gate* de acceso en tiempo real vive en tu tabla `Entitlement` local.

**Regla de entitlements (la que pide explícitamente el brief):** ninguna ruta de tu API consulta a Stripe para decidir si un request procede. Todas leen `Entitlement` local (con Redis como caché de esa fila para el hot path de rate limiting). Stripe solo se consulta de forma síncrona en flujos administrativos poco frecuentes (portal de facturación, cambio de plan iniciado por el usuario).

**Rate limiting y colas (Redis):** un rate limiter por organización (token bucket, clave `ratelimit:{orgId}`) delante de cualquier reenvío a Hermes, más una cola (BullMQ/RQ/Celery según stack) para: (a) aprovisionamiento asíncrono de `HermesInstance` en el alta, (b) apagado por inactividad, (c) emisión de eventos de medición a Stripe con reintentos.

#### Fase 2 — Frontend del dashboard (Next.js 15, App Router)

- `apps/dashboard/` con App Router, TypeScript, Tailwind, shadcn/ui — reutilizar los mismos tokens de diseño del skin de la Parte 1 (paleta, radios) para que visualmente el dashboard de cliente y el Hermes "Grok-skinned" del usuario final se sientan de la misma familia, sin compartir código (son productos distintos, solo comparten lenguaje visual).
- Auth multi-tenant por organización: **Better Auth** (recomendado si quieres control total del esquema de organizaciones/roles en tu propia Postgres sin dependencia externa de pago) o **Clerk** (recomendado si prefieres velocidad de entrega y aceptas el costo/dependencia de un proveedor gestionado). Ambos soportan el patrón "organización" nativamente; la elección no bloquea el resto del plan — decidirla en paralelo a la Fase 1 sin retrasar el backend.
- Páginas mínimas: `/onboarding` (alta + Stripe Checkout), `/billing` (Stripe Customer Portal embebido/redirigido), `/usage` (créditos consumidos vs. incluidos, leyendo `Entitlement` vía tu API, nunca Stripe directo), `/agent` (la superficie donde el cliente interactúa con su instancia de Hermes — chat, ver skills, ver estado — todo proxied por tu backend).
- El frontend **nunca** llama a Hermes directamente ni conoce el host interno de `HermesInstance`; todo pasa por rutas de tu propio backend (`/api/agent/chat`, que internamente resuelve el `HermesInstance` del tenant autenticado y reenvía a `http://<internalHost>:8642/v1/chat/completions`).

#### Fase 3 — Cableado del API server de Hermes + prueba con profile de prueba

1. Aprovisionar un tenant de prueba: `hermes profile create tenant-demo`, generar `API_SERVER_KEY` aleatoria (32+ bytes), escribirla vía `hermes -p tenant-demo config set API_SERVER_ENABLED true` + `hermes -p tenant-demo config set API_SERVER_KEY <key>`, arrancar `tenant-demo gateway start` (o el contenedor equivalente si ya se contenerizó según 2.2 Opción A).
2. Verificar aislamiento básico: `curl http://<host-tenant-demo>:8642/health` (sin auth) y `curl -H "Authorization: Bearer <key>" http://<host-tenant-demo>:8642/v1/models` devuelven lo esperado; confirmar que una segunda instancia de otro tenant de prueba con otra clave **no** responde a la clave del primero (test explícito de no-cruce, dado el hallazgo de 2.2).
3. Cablear tu backend: endpoint `/api/agent/chat` → valida `Entitlement` (créditos disponibles, plan activo) → rate limit Redis → resuelve `HermesInstance` del tenant → reenvía a `POST http://<internalHost>:8642/v1/chat/completions` con la `API_SERVER_KEY` descifrada solo en memoria de proceso → registra `ApiCallLog` y decremento de `creditsUsed` → devuelve streaming (SSE/```chat/completions``` con `stream: true```) al frontend.
4. Definir el ciclo de vida operativo del `HermesInstance`: aprovisionar en `checkout.session.completed`, arrancar bajo demanda si está `stopped` y llega tráfico, apagar tras N minutos de inactividad (job en cola), destruir (con export previo vía `hermes profile export`) al cancelar suscripción tras el periodo de retención.
5. Prueba de extremo a extremo: alta con tarjeta de test de Stripe → webhook crea `Entitlement` → login en el dashboard → primer mensaje de chat contra `tenant-demo` → verificar decremento de créditos → simular `invoice.payment_failed` (evento de test de Stripe CLI) → verificar que el acceso pasa a modo de gracia y luego se corta según la ventana definida.

### 2.4 Seguridad y compliance (puntos no negociables)

- `API_SERVER_KEY` de cada tenant: generada por tu backend (no reutilizar una clave humana), cifrada en reposo, descifrada solo en el proceso que hace el `fetch` a Hermes, nunca logueada.
- Nunca exponer `HermesInstance.internalHost` ni `api_server_key` al frontend, bajo ninguna circunstancia — ni siquiera cifrada, ni en un JWT.
- No usar el modo multiplexado (2.2 Opción B) hasta confirmar que el bug de aislamiento por `run_id` está resuelto en la versión de Hermes desplegada; si en el futuro se adopta, los endpoints de control de *run* (`stop`, `steer`, `approval`) deben quedar detrás de una capa propia que verifique la propiedad del `run_id` contra tu propia tabla de auditoría antes de reenviar la petición — no confiar en el aislamiento nativo de Hermes para esa superficie.
- `--host` de cualquier gateway de Hermes siempre `127.0.0.1` o una red interna sin salida a internet; jamás `0.0.0.0` publicado directamente.
- Bind del webhook de Stripe con verificación de firma obligatoria (`stripe.Webhook.construct_event`) y `STRIPE_WEBHOOK_SECRET` por entorno, nunca hardcodeado.

### 2.5 Riesgos y mitigaciones

| Riesgo | Mitigación |
|---|---|
| Bug de aislamiento cross-tenant en gateway multiplexado (2.2) | No usarlo en el lanzamiento; Opción A (proceso/contenedor por tenant) por defecto. |
| Costo de un contenedor Hermes por tenant, incluso inactivo | Apagado por inactividad + arranque bajo demanda gestionado por cola; medir coste real antes de considerar multiplexado. |
| Desincronía entre Stripe y `Entitlement` local si se pierde un webhook | Idempotencia por `event.id` + reconciliación periódica (`job` diario que compara `Subscription.status` local contra `stripe.Subscription.retrieve` para las N organizaciones con actividad reciente) — no reemplaza el gate en tiempo real (sigue siendo local), es solo una red de seguridad contra webhooks perdidos. |
| Fuga o reutilización de `API_SERVER_KEY` de un tenant | Rotación programable desde el dashboard de cliente (regenerar clave → reconfigurar instancia → invalidar la anterior). |
| Medición de uso (metered billing) duplicada o perdida por fallos de red hacia Stripe | Cola con reintentos + `ApiCallLog` local como fuente de verdad auditable, reconciliable contra el reporte de uso de Stripe. |

### 2.6 Entregables y orden de trabajo (resumen)

1. **Backend**: esquema Prisma + migraciones, endpoint de webhooks con idempotencia, mapeo plan→entitlement en código, rate limiter Redis, cola de aprovisionamiento.
2. **Frontend**: Next.js 15 con auth multi-tenant, páginas de onboarding/billing/usage/agent, reutilizando tokens visuales del skin de la Parte 1.
3. **Cableado Hermes**: aprovisionamiento de `HermesInstance` por tenant (Opción A), endpoint proxy `/api/agent/chat`, prueba end-to-end con `tenant-demo` y evento de Stripe de test para cada uno de los tres webhooks obligatorios.

---

## 3. Cómo se combinan las dos partes

Son independientes en código y en equipo — no hay bloqueo entre ellas. El único punto de contacto es de **lenguaje visual**: los tokens de color/radio definidos en `theme/grok-skin.yaml` (Parte 1) deberían reutilizarse como referencia de diseño (no como dependencia de código) al configurar Tailwind/shadcn en el dashboard SaaS (Parte 2), para que el producto se sienta consistente entre "el agente Hermes con skin Grok" y "el panel de cliente que lo factura".

### Próximos pasos inmediatos

- Parte 1: ejecutar la Fase 0 (sección 1.3) contra una instalación real de `hermes dashboard` — es el único paso que desbloquea todo lo demás con certeza en vez de suposición.
- Parte 2: decidir Better Auth vs. Clerk (no bloquea el inicio del backend) y arrancar el esquema Prisma + webhook de Stripe con la CLI de Stripe en modo test (`stripe listen --forward-to localhost:.../webhooks/stripe`).
