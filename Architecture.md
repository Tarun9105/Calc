# SmartCalc Architecture

## Stack
- Flutter stable
- Dart
- Riverpod for state management
- Hive for local persistence
- `decimal` for precision-sensitive formatting paths
- `flutter_test`, `mocktail`, and `integration_test`

## Architecture Style
Feature-first layered architecture:

- `presentation`: Flutter widgets and screens
- `application`: Riverpod state and orchestration
- `domain`: pure-Dart business logic
- `core`: shared infrastructure, storage, theming, utilities, shared widgets

The calculation engine stays pure Dart with no Flutter dependency.

## Folder Structure
```text
lib/
  app/
    app.dart
    theme.dart
  core/
    storage/
    utils/
    widgets/
  features/
    calculator/
      application/
      domain/
      presentation/
    history/
      application/
      domain/
      presentation/
    memory/
      application/
      domain/
      presentation/
    settings/
      application/
      domain/
      presentation/
  main.dart
test/
  unit/
  widget/
integration_test/
docs/
```

## App Flow
1. App boots through `main.dart`.
2. App shell loads theme and providers.
3. Calculator screen renders current expression and result.
4. Key taps dispatch intents to the calculator controller.
5. Controller delegates evaluation to the pure-Dart engine.
6. History, memory, and settings persist through repository services.

## Initial Technical Decisions
- Start with a recursive-descent expression engine because it is easy to test and extend.
- Keep angle mode conversion inside the evaluator layer, not in the UI.
- Keep persistence behind service interfaces so we can add Hive later without changing the domain contracts.
- Build portrait calculator flow first, then extend the same app for landscape scientific controls.

