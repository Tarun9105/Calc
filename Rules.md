# SmartCalc Build Rules

## Working Rules
- Read `PRD.md`, `Architecture.md`, `Rules.md`, `Phases.md`, `Design.md`, and `Memory.md` before continuing implementation work.
- Treat `SmartCalc_Documentation.docx` as the source specification when conflicts appear.
- Prefer small, phase-based commits.
- Keep business logic out of widgets.

## Library Rules
- Use Flutter, Dart, Riverpod, and Hive as the default stack.
- Avoid adding extra state-management libraries.
- Avoid adding analytics, ads, or network SDKs in v1.
- Avoid heavyweight UI kits unless there is a clear product need.

## Code Rules
- Keep the calculation engine pure Dart and independently testable.
- Use immutable state objects for application state.
- Centralize colors and design tokens in `lib/app/theme.dart`.
- Do not hardcode per-widget colors or brittle pixel widths when a layout abstraction can be used.
- Every async storage path must handle failure without crashing the app.

## Error Rules
- Show user-friendly messages for invalid expressions, divide-by-zero, overflow, and domain errors.
- Never expose raw exceptions to the UI.
- No silent math corruption: if a result is invalid, surface a real error state.

## Delivery Rules
- Work phase by phase from `Phases.md`.
- Each implementation phase should have its own branch.
- Update `Memory.md` whenever meaningful progress is made.
- Do not claim a phase is complete until code structure and tests for that slice exist.

