# EMERGE System Enhancements Proposal

This document proposes focused, incremental changes to make the EMERGE Mudlet system more predictable, extensible, and testable without breaking the event‑only “golden rule”. The goals are to:

- Increase determinism (ordering, lifecycle, conflicts)
- Standardize events and payloads (shared language across modules)
- Improve safety (error isolation, validation)
- Simplify configuration and secrets handling
- Provide scaffolding for tests and GMCP normalization
- Document capabilities and expectations so modules integrate smoothly

## Summary of Proposed Changes

- Core event taxonomy and payload schemas with helper utilities
- Deterministic event dispatch: priorities, safe wrapping, once/debounce
- Formal module lifecycle events and cleanup rules
- Config schema registration, namespacing, and change events
- Capability registry for provide/require negotiation
- Required GMCP normalization layer that emits stable `gmcp.*` events
- Error isolation plus structured logging and metrics
- Test helpers for Mudlet API and GMCP payloads
- Manifest/doc updates to declare events, config, capabilities
- A phased migration plan with acceptance criteria

---

## 1) Core Event Taxonomy & Schemas

Define a canonical set of top‑level namespaces and event names. Each event specifies payload fields, required/optional keys, and invariants.

- `emerge.*`
  - `emerge.config.changed`: `{ key: string, old: any, new: any, source: string? }`
  - `emerge.state.changed`: `{ key: string, old: any, new: any }`
  - `emerge.tick`: `{ t: number }` every 1s; coalesced by manager
  - `emerge.heartbeat`: `{ t: number, lag_ms: number? }` every 5s
  - `emerge.module.error`: `{ module: string, event: string, error: string, traceback: string? }`

- `module.lifecycle.*`
  - `module.lifecycle.preload`: `{ id: string }`
  - `module.lifecycle.load`: `{ id: string }`
  - `module.lifecycle.postload`: `{ id: string }`
  - `module.lifecycle.preunload`: `{ id: string }`
  - `module.lifecycle.unload`: `{ id: string }`

- `gmcp.*` (normalized, see Section 6)
  - `gmcp.char.vitals`: `{ hp, maxhp, mp, maxmp, ep, maxep, wp, maxwp, bal:boolean, eq:boolean, prone:boolean, mounted:boolean }`
  - `gmcp.char.afflictions`: `{ gained: string[]?, lost: string[]?, list: string[] }`
  - `gmcp.room.info`: `{ id:number?, name:string, area:string, coords:{x?:number,y?:number,z?:number}? }`
  - `gmcp.target.info`: `{ name?:string, class?:string, level?:number }`

- `combat.*`
  - `combat.aff_gained`: `{ name:string, source?:string }`
  - `combat.aff_lost`: `{ name:string }`
  - `combat.limb_update`: `{ limb:string, percent:number }`
  - `combat.preset_state`: `{ name:string, active:boolean }`

- `curing.*`
  - `curing.queue.request`: `{ action:string, args:any?, priority?:number, id?:string }`
  - `curing.queue.update`: `{ id:string, state:'queued'|'sent'|'done'|'failed', reason?:string }`
  - `curing.defence.ensure`: `{ name:string, state:'up'|'down'|'toggle' }`
  - `curing.action.executed`: `{ action:string, ok:boolean, latency_ms?:number, id?:string }`

Invariants:
- Event names use dot‑namespaces; payload keys are snake_case.
- Timestamps are seconds (os.time()) unless otherwise specified.
- Boolean flags are explicit; no truthy coercion relied upon downstream.

## 2) Event Dispatch Utilities

Introduce a tiny helper layer to make event handling deterministic and safe.

API (pseudocode Lua):

```lua
-- Register/unregister
emerge.events.on(event, handler, opts) -- opts: { priority=100, once=false, id=string? }
emerge.events.off(event, handler_or_id)

-- Emit safely (wrap with pcall)
emerge.events.emit(event, payload) -- continues on handler error, emits emerge.module.error

-- Helpers
emerge.events.once(event, handler, opts)
emerge.events.debounce(event, handler, ms, opts) -- coalesce rapid bursts
```

Rules:
- Handlers run in ascending `priority` (default 100). Stable ordering for equal priorities.
- Exceptions are caught; the dispatcher continues and emits `emerge.module.error` with traceback.
- `once=true` auto‑unregisters after first run.
- Debounce for chatty sources (e.g., GMCP login burst) to reduce thrash.

## 3) Module Lifecycle

Standardize lifecycle as events and expectations.

Sequence when loading a module `X`:
1. Emit `module.lifecycle.preload {id='X'}`
2. Module file executes and registers handlers/aliases/triggers
3. Emit `module.lifecycle.load {id='X'}`
4. After all modules loaded, emit `module.lifecycle.postload {id='X'}` for each

Unloading:
1. Emit `module.lifecycle.preunload {id='X'}`
2. Module removes aliases, triggers, timers, and event handlers (mandatory)
3. Emit `module.lifecycle.unload {id='X'}`

Acceptance: unloading leaves no `tempTimer`, handler, or alias references.

## 4) Configuration Conventions & Validation

- Namespacing: keys live under `module_id.*` only (no global keys).
- Registration:

```lua
emerge.config.register('emerge.ai', {
  schema = {
    ["provider"] = { type='string', enum={'ollama','groq','openai'}, default='ollama' },
    ["temperature"] = { type='number', min=0, max=2, default=0.7 },
    ["max_tokens"] = { type='integer', min=1, max=8192, default=2048 },
    ["api_keys.groq"] = { type='secret' },
  },
  on_change = function(key, old, new) raiseEvent('emerge.config.changed', {key=key, old=old, new=new, source='emerge.ai'}) end,
})
```

- Access: `emerge.config.get(key, default?)`, `emerge.config.set(key, value)` (validates against schema).
- Secrets: stored separately and never echoed; redacted in logs (`••••`).
- Diff‑safe save: atomic write to config file.

## 5) Capability Registry

Enable modules to declare what they provide and require.

```lua
emerge.capabilities.provide('curing.queue', { version='1.0', module='emerge.curing' })
emerge.capabilities.require('gmcp.normalized', '>=1.0') -- warn if unmet
emerge.capabilities.has('curing.queue', '>=1.0') -- boolean
```

Effects:
- During load, unmet requirements warn with a single aggregated message and emit `emerge.module.error` with type `capability.missing`.
- Discovery API to list providers and versions.

## 6) GMCP Normalization Layer (Required Module)

Add a small required module `emerge-gmcp` to translate raw GMCP into normalized `gmcp.*` events and coalesce bursts.

Responsibilities:
- Subscribe to Mudlet GMCP hooks; map raw payloads to stable shapes.
- Debounce/coalesce login and movement bursts (e.g., 50–100ms window).
- Maintain last‑known state to emit `gained/lost` deltas for afflictions.
- Avoid direct Mudlet API usage in other modules; they consume `gmcp.*`.

Example:
```lua
-- On raw gmcp.Char.Vitals
emerge.events.emit('gmcp.char.vitals', {
  hp = gmcp.Char.Vitals.hp,
  maxhp = gmcp.Char.Vitals.maxhp,
  mp = gmcp.Char.Vitals.mp,
  maxmp = gmcp.Char.Vitals.maxmp,
  bal = gmcp.Char.Vitals.balance == '1',
  eq = gmcp.Char.Vitals.equilibrium == '1',
  prone = state.prone or false,
})
```

## 7) Error Handling, Logging, and Metrics

- Safe dispatch (Section 2) isolates handler errors and surfaces structured reports.
- Logging API: `emerge.log(level, source, msg, data?)` with levels: `debug, info, warn, error`.
- Redact secrets, include event name, handler id, and module in error logs.
- Counters: track event dispatch counts and average handler latency per event for debugging.

## 8) Deterministic Ordering & Conflict Resolution

- Priorities provide ordering; document standard ranges:
  - 0–49: core/normalization
  - 50–99: state maintenance
  - 100–149: decision making (curing/rules)
  - 150–199: UI/feedback/logging
- Optional `stop_propagation` convention: a handler may return `{ stop=true }` to halt further handlers when appropriate (avoid overuse; only for mutually exclusive actions like a single send‑to‑queue decision).

## 9) Test Scaffolding

Provide reusable test helpers under `tests/helpers/` to reduce duplication.

- `tests/helpers/mudlet.lua`: stubs for `raiseEvent`, `tempTimer`, `cecho`, `yajl`, `getMudletHomeDir`, `downloadFile`, etc.
- `tests/helpers/events.lua`: in‑memory dispatcher matching Section 2 semantics.
- `tests/helpers/gmcp.lua`: sample payloads and emitters for common GMCP messages.

Usage pattern:
```lua
local t = require('tests.helpers')

t.events.on('curing.queue.request', function(p)
  t.assert.equal(p.action, 'eat')
end)

t.events.emit('curing.queue.request', { action='eat', args='kelp' })
```

## 10) Documentation & Manifest Updates

- Module manifest additions:
  - `events`: `{ emitted: string[], consumed: string[] }`
  - `capabilities`: `{ provides: {name, version}[], requires: {name, range}[] }`
  - `config`: `{ schemaVersion: string }`
- Repository docs:
  - Add `resources/events.md` detailing taxonomy and schemas (Section 1).
  - Add `resources/capabilities.md` listing known capabilities and versions.
  - Update README to explain lifecycle and configuration registration.

## 11) Performance Guidance

- Standard debounce defaults for GMCP bursts (50–100ms).
- Rate‑limit external requests (AI etc.): shared helper uses token bucket per provider.
- Avoid heavy work in hot paths; prefer precomputed tables and early returns.

## 12) Security & Configuration

- Secrets only via `emerge.config.set('module.key', value)`; never printed.
- Separate file or section for secrets with masked logs and backups disabled.
- `emodule token <provider> <value>` routes to `emerge.config.set` with `type='secret'`.

## 13) Migration Plan

Phase 1 (Low risk)
- Add event utilities (Section 2) and logging API (Section 7).
- Document core event taxonomy and add test helpers (Sections 1 & 9).

Phase 2 (Medium)
- Implement GMCP normalization module and switch consumers to `gmcp.*`.
- Introduce lifecycle events and update modules to clean up in `preunload`.

Phase 3 (Medium)
- Add config registration/validation and migrate modules to namespaced keys.
- Add capability registry; declare provides/requires in manifests.

Phase 4 (Hardening)
- Apply priorities across modules and tune ordering conflicts.
- Write litmus tests for determinism and error isolation.

## 14) Acceptance Criteria

- Deterministic ordering: two handlers for `curing.queue.request` run in priority order; optional stop works.
- Error isolation: a thrown error in one handler does not prevent others; an `emerge.module.error` is emitted and logged.
- Hot reload: modules emit lifecycle events and leave no handlers/aliases/timers after unload.
- GMCP normalization: all modules consume `gmcp.*`; raw GMCP use is centralized.
- Config: invalid sets are rejected; `emerge.config.changed` fires with correct payload.
- Tests: helpers in place; at least one module unit test uses them.

## 15) Appendix: Minimal API Sketches

Event utilities:
```lua
local E = { _h = {}, _id = 0 }
function E.on(ev, fn, o)
  o = o or {}; local p = o.priority or 100; local id = o.id or (ev.."#"..tostring(E._id+1)); E._id = E._id + 1
  local list = E._h[ev] or {}; table.insert(list, {id=id, fn=fn, p=p, once=o.once})
  table.sort(list, function(a,b) if a.p==b.p then return a.id<b.id else return a.p<b.p end end)
  E._h[ev] = list; return id
end
function E.off(ev, h)
  local list = E._h[ev]; if not list then return end
  for i=#list,1,-1 do if list[i].fn==h or list[i].id==h then table.remove(list,i) end end
end
function E.emit(ev, payload)
  local list = E._h[ev]; if not list then return end
  for i=#list,1,-1 do local h=list[i]
    local ok,ret = pcall(h.fn, payload)
    if not ok then raiseEvent('emerge.module.error', {module='?', event=ev, error=tostring(ret)}) end
    if h.once then table.remove(list,i) end
    if type(ret)=='table' and ret.stop then break end
  end
end
return E
```

Config registration:
```lua
local C = { schemas = {}, values = {}, secrets = {} }
function C.register(ns, def) C.schemas[ns] = def end
function C.get(key, default)
  -- enforce namespacing and defaults
end
function C.set(key, value)
  -- validate against schema, handle secrets, emit emerge.config.changed
end
return C
```

These sketches illustrate intent; production code should match existing style and Mudlet environment expectations.

---

This proposal keeps changes incremental, focused on predictable behavior and developer ergonomics, without constraining module creativity or violating the event‑only rule.
