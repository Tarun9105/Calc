# SmartCalc Memory

## Current Status
- Date: 2026-08-16
- Source specification read from `SmartCalc_Documentation.docx`
- Repository initialized locally
- Planning docs created and committed on `phase/0-planning-foundation`
- Phase 1 domain layer expanded with stronger scientific function coverage and error handling
- Phase 2 portrait calculator UI scaffold added on `phase/2-portrait-ui`
- Phase 3 scientific landscape scaffold added on `phase/3-scientific-mode`

## Branch Strategy
- `main`
- `phase/0-planning-foundation`
- `phase/1-domain-engine`
- `phase/2-portrait-ui`
- `phase/3-scientific-mode`
- `phase/4-history-memory`
- `phase/5-settings-accessibility`
- `phase/6-release-readiness`

## Implementation Notes
- Flutter SDK is not currently available in this environment, so the repository is being scaffolded manually.
- Start with pure-Dart domain code and a Flutter-style folder structure.
- Add real Flutter wiring once the SDK is available locally.
- Phase 1 currently supports arithmetic precedence, powers, constants, trig, logs, inverse trig validation, factorial, and clearer domain errors.
- Phase 2 now includes a stateful calculator screen, display panel, reusable key widget, portrait keypad layout, and a starter widget test.
- Phase 3 now adds angle-mode-aware evaluation state, a scientific keypad for landscape, scientific theme tokens, and a landscape widget test.

## Next Recommended Actions
- Commit the scientific landscape scaffold
- Once Flutter finishes installing, run `flutter test` and fix any compile/runtime issues
- Continue into `phase/4-history-memory` with persistent history and memory actions

## Commit History
- `020c07c` `docs: add SmartCalc planning foundation`
- `0aab1ab` `feat: scaffold SmartCalc phase 1 foundation`
- `64dc443` `feat: expand SmartCalc phase 1 engine`
- `f6b6d6c` `feat: add SmartCalc portrait calculator UI`
