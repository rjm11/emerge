# Repository Guidelines

## Project Structure & Module Organization
- Source: `modules/` (Lua modules). Core lives in `modules/required/` (e.g., `emerge-core.lua`); examples/optional in `modules/optional/`.
- Manager: `manager/emerge-manager.lua` (module loader and registry).
- Tests: `tests/` (e.g., `test_emerge_core.lua`, runners in `run_*.lua`).
- Docs & assets: `resources/` and `.github/` (PR template).

## Build, Test, and Development Commands
- Install manager in Mudlet: `lua installModule("manager/emerge-manager.lua")`.
- Load a module in Mudlet: `emodule load emerge-core` (use the module name without `.lua`).
- Run core tests: `lua dofile("tests/run_core_tests.lua")`.
- Run all tests: `lua dofile("tests/run_all_tests.lua")` (discovers `tests/test_*.lua`).

## Coding Style & Naming Conventions
- Language: Lua; indentation: 2 spaces; line width: ~100 chars.
- Module files: `emerge-<feature>.lua` (e.g., `emerge-gmcp.lua`).
- Events: dot‑namespaced (e.g., `emerge.module.loaded`, `combat.tick`).
- Follow the module template in `README.md`; initialize via `EMERGE:registerModule(...)` and raise events, not direct calls.

## Testing Guidelines
- Place tests in `tests/` and name them `test_*.lua` for discovery by the aggregator.
- Provide a `run_all()` (preferred) or `quick()` function from test suites to integrate with runners.
- Aim for ≥ 80% coverage (see PR checklist). Include negative and event‑ordering cases.

## Commit & Pull Request Guidelines
- Commit style: concise, imperative; Conventional‑Commits‑like types/scopes are welcome (e.g., `chore(manager): ...`, `docs(spec): ...`).
- Update versioning where applicable (module header, `manifest.json`, and `CHANGELOG.md`).
- PRs must include: clear summary, linked issues, test notes/output, screenshots or logs if UI/behavioral.
- Required checks: event‑driven only (no direct inter‑module calls), tests added/updated and passing locally.

## Security & Configuration Tips
- Do not commit secrets or tokens. Keep configuration in module configs, not hardcoded.
- Follow the “Golden Rule”: communicate via `raiseEvent(...)` only; never call other modules directly.

## Architecture Overview
- Event‑driven core: modules register handlers and emit events. Prefer small, focused modules with explicit inputs/outputs.
