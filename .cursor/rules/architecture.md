### Event-driven architecture

- Modules never call each other directly; communicate via events only.
- Use Mudlet’s `raiseEvent(...)` or the project’s event façade.
- Emit lifecycle events on load/unload; cleanly register/unregister handlers.

### Module structure & load order

- Follow the module template in `README.md`.
- Core/manager must initialize before optional or class modules (see `CLAUDE.md`).

### Event naming

- Convention: `module.subject.action`.
- Validate names before use; avoid catch-all or ambiguous events.

### Performance & state

- Keep handlers non-blocking and short; avoid loops that block UI.
- Persist state intentionally; use provided state/config APIs when available.
