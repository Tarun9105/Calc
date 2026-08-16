# SmartCalc PRD

## Product
SmartCalc is an Android scientific calculator built with Flutter and targeted for Google Play Store release.

## Target Users
- General users who need fast everyday arithmetic
- Students who need scientific functions, memory, and history
- Engineers and power users who need precision, angle modes, and reusable calculations
- Accessibility-focused users who need TalkBack support, large text, and high contrast

## Goals
- Deliver a fast offline-first calculator with reliable scientific functions
- Match the familiarity of the iOS calculator interaction model while remaining Android-ready
- Publish a stable Play Store release with strong accessibility and no crashes

## In Scope
- Basic arithmetic
- Scientific functions
- Memory operations
- Local calculation history
- Settings for angle mode, theme, text size, precision, haptics, and sound
- Local persistence for history, memory, and settings
- Google Play Store release preparation

## Out of Scope For v1
- Graphing
- Matrix solving
- Equation solving
- Cloud sync
- iOS release

## Success Metrics
- Cold start under 1.5s on mid-tier Android devices
- No crashes in pre-launch testing across target devices
- 100% validation on the reference math set
- Fully usable offline with no unnecessary permissions

## Core User Stories
- As a user, I can perform basic arithmetic quickly in portrait mode.
- As a student, I can access scientific functions in landscape mode.
- As a user, I can store values in memory and recall them later.
- As a user, I can reopen the app and still have my history and settings.
- As an accessibility user, I can use the app with TalkBack and larger text.

