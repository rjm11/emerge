### Authoritative context sources

- `CLAUDE.md`: top-level rules (agents-first, SemVer, event-driven design, commands).
- `CLAUDE REFERENCE/**`: architecture, development workflows, migration plans, handler design, etc.
- `resources/wiki-repo/**`: Achaea mechanics and API reference material.
- `README.md`, `REPOSITORY_STRUCTURE.md`: module template, discovery model, commands.

### Usage guidance

- Before coding, scan relevant docs. Cite paths in your prompt so Cursor loads them.
- When reasoning about game mechanics, prefer `resources/wiki-repo/**` and note class/system specifics.
- For architectural choices, prefer RIME-inspired patterns per `CLAUDE.md` and `CLAUDE REFERENCE/architecture`.
