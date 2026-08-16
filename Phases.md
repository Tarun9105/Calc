# SmartCalc Phases

## Phase 0: Planning And Repo Setup
- Create durable project docs
- Initialize Git
- Establish folder structure and branch strategy

Branch: `phase/0-planning-foundation`

## Phase 1: Domain Engine Foundation
- Implement pure-Dart calculator models
- Implement tokenizer and parser
- Support numbers, parentheses, unary signs, `+`, `-`, `*`, `/`, `%`
- Add angle-mode-aware scientific function hooks
- Add unit tests for precedence and error handling

Branch: `phase/1-domain-engine`

## Phase 2: App Shell And Portrait Calculator UI
- Create app shell, theme tokens, and calculator screen
- Build portrait keypad with iOS-style layout
- Connect keypad input to calculator state

Branch: `phase/2-portrait-ui`

## Phase 3: Scientific Landscape Mode
- Add landscape scientific keypad
- Wire advanced functions into the engine and UI
- Preserve portrait and landscape parity

Branch: `phase/3-scientific-mode`

## Phase 4: History And Memory
- Add persistent history
- Add memory actions and state
- Add clear and recall flows

Branch: `phase/4-history-memory`

## Phase 5: Settings, Accessibility, And Polish
- Theme options
- Text scaling and semantics
- Haptics and sound toggles
- Precision settings and error-state polish

Branch: `phase/5-settings-accessibility`

## Phase 6: QA, Release Prep, And Play Store Readiness
- Reference math validation set
- Integration and smoke testing
- Release configuration and listing prep

Branch: `phase/6-release-readiness`

