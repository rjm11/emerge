# EMERGE Events Specification

Authoritative taxonomy and payload schemas for events used by EMERGE modules. This document standardizes names, shapes, and conventions so modules interoperate predictably while preserving the event‑only rule.

Version: 1.0 (draft)

## Goals
- Consistent event names and payload shapes.
- Deterministic ordering and clear lifecycle semantics.
- Safe evolution with versioning and compatibility notes.
- Minimal but sufficient payloads for common use cases.

## Conventions
- Namespaces use dot notation: `namespace.topic.action`.
- Keys use snake_case. Enums are lowercase strings.
- Timestamps are seconds from `os.time()` unless noted.
- Booleans are explicit; no implicit truthy semantics downstream.
- Schemas below list: required (•) vs optional (◦) fields.

## Common Types
- ID: string (stable identifier) or number where indicated.
- Percent: number 0–100.
- Coords: `{ x:number, y:number, z?:number }`.
- Range strings use semver constraints, e.g., `">=1.0 <2.0"`.

---

## 1. Core EMERGE

### 1.1 `emerge.config.changed`
- When: A config key changes via manager or module.
- Schema:
  - • `key`: string (namespaced: `module.key`)
  - • `old`: any
  - • `new`: any
  - ◦ `source`: string (module id initiating change)
  - ◦ `ts`: number
- Example:
```lua
{ key='emerge.ai.temperature', old=0.7, new=0.8, source='emerge.ai', ts=os.time() }
```

### 1.2 `emerge.state.changed`
- When: Stable, shared state changes (rarely used; prefer module‑local state).
- Schema: same shape as `emerge.config.changed`.

### 1.3 `emerge.tick`
- When: Manager heartbeat (coalesced)
- Schema: • `t`: number

### 1.4 `emerge.heartbeat`
- When: Lower‑frequency health ping
- Schema: • `t`: number; ◦ `lag_ms`: number

### 1.5 `emerge.module.error`
- When: A handler throws or a module reports errors
- Schema:
  - • `module`: string
  - • `event`: string
  - • `error`: string
  - ◦ `traceback`: string
  - ◦ `handler_id`: string
  - ◦ `data`: table (non‑secret context)

---

## 2. Module Lifecycle

Lifecycle events are emitted by the manager around load/unload. Modules must clean up handlers, timers, triggers, and aliases in `preunload`.

- `module.lifecycle.preload` • `{ id }`
- `module.lifecycle.load` • `{ id }`
- `module.lifecycle.postload` • `{ id }`
- `module.lifecycle.preunload` • `{ id }`
- `module.lifecycle.unload` • `{ id }`

Compatibility: existing `system.module.loaded/unloaded` should be aliased to `module.lifecycle.load/unload`.

---

## 3. GMCP (Normalized)

A required normalization layer emits these events from raw GMCP, with optional debounce (50–100ms) and delta tracking for gains/losses.

### 3.1 `gmcp.char.vitals`
- Schema:
  - • `hp`, • `maxhp`, • `mp`, • `maxmp`: integer
  - ◦ `ep`, ◦ `maxep`, ◦ `wp`, ◦ `maxwp`: integer
  - • `bal`, • `eq`: boolean
  - ◦ `prone`, ◦ `mounted`: boolean
  - ◦ `bleeding`: integer
  - ◦ `ts`: number

### 3.2 `gmcp.char.afflictions`
- Schema:
  - • `list`: string[] (current full set)
  - ◦ `gained`: string[]
  - ◦ `lost`: string[]
  - ◦ `ts`: number
- Note: `gained/lost` computed against last known set.

### 3.3 `gmcp.char.defences`
- Schema:
  - • `list`: string[]
  - ◦ `gained`: string[]
  - ◦ `lost`: string[]

### 3.4 `gmcp.room.info`
- Schema:
  - • `name`: string
  - ◦ `id`: number
  - ◦ `area`: string
  - ◦ `coords`: Coords
  - ◦ `exits`: string[] (dir names)

### 3.5 `gmcp.target.info`
- Schema:
  - ◦ `name`: string
  - ◦ `class`: string
  - ◦ `level`: number

### 3.6 `gmcp.char.balance`
- Schema: • `bal`: boolean; • `eq`: boolean; ◦ `ts`: number
- Note: Some systems prefer a dedicated balance event to reduce noise from full vitals.

---

## 4. Combat

These are high‑level abstractions produced by combat modules using normalized GMCP and/or triggers.

### 4.1 `combat.aff_gained`
- Schema: • `name`: string; ◦ `source`: string

### 4.2 `combat.aff_lost`
- Schema: • `name`: string

### 4.3 `combat.limb_update`
- Schema: • `limb`: string; • `percent`: Percent

### 4.4 `combat.preset_state`
- Schema: • `name`: string; • `active`: boolean
- Example: `{ name='prep', active=true }`

---

## 5. Curing

Curing events coordinate queue decisions, action outcomes, and defence upkeep. Deterministic ordering is important; see Section 8.

### 5.1 `curing.queue.request`
- When: A module requests a curing action be queued.
- Schema:
  - • `action`: string (e.g., `eat`, `apply`, `sip`, `stand`)
  - ◦ `args`: any (e.g., `kelp`, `restoration head`)
  - ◦ `priority`: number (lower runs earlier; default 100)
  - ◦ `id`: string (correlates with updates)
  - ◦ `requires`: string[] (e.g., `{ 'bal', 'eq' }`)
  - ◦ `cooldown_ms`: number
- Propagation: a handler may return `{ stop=true }` to prevent duplicate queueing when a single winner is desired.

### 5.2 `curing.queue.update`
- Schema:
  - • `id`: string
  - • `state`: `'queued'|'sent'|'done'|'failed'`
  - ◦ `reason`: string
  - ◦ `latency_ms`: number

### 5.3 `curing.defence.ensure`
- Schema: • `name`: string; • `state`: `'up'|'down'|'toggle'`

### 5.4 `curing.action.executed`
- Schema: • `action`: string; • `ok`: boolean; ◦ `latency_ms`: number; ◦ `id`: string

---

## 6. UI/Feedback (Optional)

Events intended for echo/GUI modules; keep read‑only side effects.

- `ui.notify`: • `{ level:'info'|'warn'|'error', text:string, source?:string }`
- `ui.debug`: • `{ source:string, text:string, data?:table }`

---

## 7. Ordering & Priorities

Handlers may specify a priority; lower runs first. Stable ordering for equal priorities.
- 0–49: core/normalization (GMCP, adapters)
- 50–99: state maintenance (trackers)
- 100–149: decision making (curing/rules)
- 150–199: UI/feedback/logging

Propagation control:
- Return `{ stop=true }` to halt further handlers for that event when appropriate.

Error isolation:
- All dispatch should be wrapped in `pcall`; on error, emit `emerge.module.error` and continue remaining handlers.

---

## 8. Versioning & Compatibility

- This spec is v1.0. Backward‑compatible additions may add optional fields.
- Breaking changes (rename/remove fields) must bump the major version and include a compatibility adapter in the manager for one release.
- Aliases for legacy events:
  - `system.module.loaded` → `module.lifecycle.load`
  - `system.module.unloaded` → `module.lifecycle.unload`

---

## 9. Examples

### 9.1 Queue an herb and stop propagation
```lua
raiseEvent('curing.queue.request', { action='eat', args='kelp', priority=110, id='eat:kelp', requires={'bal'} })
-- In the queue manager handler
return { stop=true }
```

### 9.2 Affliction delta from normalization
```lua
raiseEvent('gmcp.char.afflictions', { list={'asthma','paresis'}, gained={'paresis'}, lost={'slickness'} })
```

### 9.3 Lifecycle cleanup
```lua
registerAnonymousEventHandler('module.lifecycle.preunload', function(p)
  if p.id == 'emerge.ai' then
    for id in pairs(emerge.ai.handlers) do killAnonymousEventHandler(emerge.ai.handlers[id]) end
  end
end)
```

---

## 10. Adoption Checklist
- Consume normalized `gmcp.*` only; avoid raw GMCP in modules.
- Register handlers with explicit priorities where ordering matters.
- Clean up all handlers/timers/aliases in `preunload`.
- Emit `curing.queue.update` with `id` for observability of queue decisions.
- Namespaced config keys; register schema; react to `emerge.config.changed`.

---

For rationale and a broader plan, see `resources/EMERGE_Enhancements_Proposal.md`.
