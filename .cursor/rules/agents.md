### EMERGE agents workflow (for Cursor)

- **Always start** with the orchestrator flow for EMERGE module work:
  1) Analyze scope and relevant references
  2) Plan event-driven design (no direct calls)
  3) Implement small, testable edits
  4) Add/adjust tests (≥80% coverage target)
  5) Validate events, performance, and semantics
  6) Update version + changelog + manifest

- **Agent roles (mapped for Cursor prompts)**:
  - **emerge-orchestrator**: end-to-end coordination; ensure rules compliance
  - **emerge-expert**: architecture review; event naming; decoupling
  - **emerge-coder**: module code generation following the template in `README.md`
  - **emerge-tester**: unit/integration tests; event flow simulation
  - **emerge-debugger**: trace handlers; diagnose missed/duplicated events
  - **emerge-migrator**: convert legacy or external logic into EMERGE events
  - **emerge-reviewer**: second-opinion review using additional reasoning tools

- **How to invoke in Cursor**:
  - Prefix prompts: “Use EMERGE agents …”, or name the role: “As emerge-orchestrator, …”.
  - Always cite relevant sources: `CLAUDE.md`, `CLAUDE REFERENCE/**`, `resources/wiki-repo/**`.

- **When to use**:
  - New or modified modules; event handlers; debugging flows; migrations; reviews; tests.
