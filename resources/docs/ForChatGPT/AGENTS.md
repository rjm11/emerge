# Repository Guidelines

## Project Structure & Modules
- `modules/required/` and `modules/optional/`: Lua modules loaded by the manager. Keep modules self‑contained and event‑driven.
- `manager/`: `emerge-manager.lua` (module loader) and `manifest.json` for discovery.
- `tests/`: Lua test suites (e.g., `tests/test_emerge_test_module.lua`).
- `REFERENCES/`, `CLAUDE REFERENCE/`, `resources/`: end‑user docs, developer guides, and examples.
- `private-repo/`: local sandbox mirroring private modules during development.

## Build, Test, and Development Commands
- No build step: modules are plain Lua loaded in Mudlet or via CLI.
- Install manager in Mudlet:
  ```lua
  downloadFile(getMudletHomeDir().."/manager/emerge-manager.lua",
    "https://raw.githubusercontent.com/rjm11/emerge/main/manager/emerge-manager.lua")
  dofile(getMudletHomeDir().."/manager/emerge-manager.lua")
  ```
- Discover modules: `emodule refresh`, list: `emodule list`, load: `emodule load emerge-core`.
- Run tests (CLI): `lua dofile("tests/test_emerge_test_module.lua")` or `lua dofile("run_core_tests.lua")`.

## Coding Style & Naming Conventions
- Language: Lua. Indentation: 2 spaces; no tabs.
- Files: `emerge-<feature>.lua`; modules expose a table and return it.
- Events only: never call other modules directly. Use `raiseEvent()` with dot‑namespaces:
  - `emerge.*`, `combat.*`, `curing.*`, `gmcp.*`, `module.*`.
- Handlers: store IDs (e.g., `self.handlers.foo`) and clean up on unload.

## Testing Guidelines
- Tests are plain Lua; prefer `tests/test_*.lua` naming.
- Keep unit tests inside `tests/` and add example usage in comments where helpful.
- Run selectively with `lua dofile("tests/<file>.lua")`; group suites in `run_core_tests.lua`.

## Commit & Pull Request Guidelines
- Branch per change: `feature/<short-name>` or `fix/<issue-id>`.
- Commits: concise, imperative subject; reference issues when relevant (e.g., `Fix: normalize event names (#42)`).
- PRs must include: purpose, approach, test notes/outputs, and any screenshots of Mudlet output.
- Ensure golden rule compliance (event‑driven), updated manifest entries, and passing tests.

## Security & Configuration Tips
- Private modules require a GitHub token with `repo` scope: `emodule token ghp_…`. Do not commit tokens.
- Do not hardcode paths; prefer `getMudletHomeDir()`.
- Avoid network calls in module init; defer to event handlers when possible.
