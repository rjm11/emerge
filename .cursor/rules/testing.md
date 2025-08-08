### Testing policy

- Target ≥80% coverage for new/changed functionality.
- Include happy-path, edge-cases, and event-flow tests.
- Keep tests fast and deterministic; avoid timing flakiness.

### Locations & commands

- Tests live under `tests/**` (see project files for specifics).
- Reference debug helpers in `CLAUDE.md` (event history, debug toggles).

### Validation

- Verify event names follow `module.subject.action`.
- Confirm handlers are registered/unregistered correctly.
- Check that no direct module calls were introduced.
