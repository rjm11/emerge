## Summary

- What does this change do and why?
- Link related issues (e.g., #123) and context.

## Change Type

- [ ] Feature
- [ ] Bug fix
- [ ] Refactor
- [ ] Documentation
- [ ] Tests

## Checklist

- [ ] Event-driven only (no direct inter-module calls)
- [ ] Semantic versioning updated (module header, CURRENT_VERSION, manifest.json, CHANGELOG.md)
- [ ] Tests added/updated and pass locally
- [ ] Coverage target considered (aim ≥ 80%)
- [ ] Adheres to 2-space Lua indentation and 100-char width
- [ ] No secrets committed (e.g., GitHub tokens)
- [ ] PR description includes test notes and screenshots/logs if applicable

## Testing Notes

- Commands used:
  - `lua dofile("run_core_tests.lua")` (core)
  - `lua dofile("run_all_tests.lua")` (aggregate)
- Output/summary:

## Additional Context

- Breaking changes? Migration steps?
- Docs updated (`REFERENCES/`, `CLAUDE REFERENCE/`) as needed
