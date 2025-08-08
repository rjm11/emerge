# Capabilities Registry

This repository uses a lightweight capability registry so modules can declare what they provide and safely depend on others.

- Provide: `emerge.capabilities.provide(name, { version='x.y.z', module='<id>' })`
- Require: `emerge.capabilities.require(name, '>=x.y.z')` (returns boolean; emits `emerge.module.error` on unmet)
- Check: `emerge.capabilities.has(name, '>=x.y.z')`

Known capabilities
- `gmcp.normalized` (provided by `emerge-gmcp`): Normalized `gmcp.*` events with stable payloads.
- `curing.queue` (planned): Curing action queue interface.

Versioning
- Accepts exact versions (e.g., `1.0.0`) or ranges in the form `>=x.y.z`.
- Use semantic versioning increments for breaking changes.

Usage example
```lua
-- In your module's init
if emerge and emerge.capabilities then
  if not emerge.capabilities.require('gmcp.normalized', '>=0.1.0') then return end
end
```
