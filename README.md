# 🧮 SmartCalc — Scientific Calculator

An offline-first, high-precision scientific calculator built with **Flutter**, **Dart**, and **Riverpod**. Designed with a refined, iOS-inspired dark aesthetic, SmartCalc delivers snappy everyday arithmetic alongside comprehensive scientific calculations, memory operations, persistent history, and rich accessibility features for Android.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Design & Aesthetics](#-design--aesthetics)
- [Architecture & Tech Stack](#-architecture--tech-stack)
- [Project Structure](#-project-structure)
- [Calculation Engine & Math Capabilities](#-calculation-engine--math-capabilities)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation & Run](#installation--run)
  - [Running Code Generation](#running-code-generation)
  - [Running Tests](#running-tests)
- [Configuration & Settings](#-configuration--settings)
- [Accessibility & Performance](#-accessibility--performance)
- [Roadmap & Phases](#-roadmap--phases)
- [Publishing & Release](#-publishing--release)
- [License & Authors](#-license--authors)

---

## 🌟 Overview

**SmartCalc** bridges the gap between clean simplicity and scientific computing power. It is tailored to offer:
- **Instant Responsiveness**: Sub-1.5s cold start with fluid key-press feedback.
- **Pure-Dart Math Engine**: Fully decoupled, highly tested recursive-descent math parser and evaluation engine.
- **Adaptive Layout**: Minimalist standard keypad in portrait mode; comprehensive scientific pad in landscape mode.
- **Local-First & Private**: Completely offline with zero trackers, ads, or unnecessary permissions.

---

## ✨ Key Features

### 1. Basic & Scientific Arithmetic
- **Standard Operations**: Addition, subtraction, multiplication, division, percentage, sign negation (`+/-`), and parentheses grouping.
- **Advanced Scientific Functions** *(available in Landscape mode)*:
  - Trigonometric: `sin`, `cos`, `tan`, `asin`, `acos`, `atan` (supports **DEG** and **RAD** angle modes).
  - Hyperbolic: `sinh`, `cosh`, `tanh`, `asinh`, `acosh`, `atanh`.
  - Logarithmic & Exponential: `ln`, `log10`, `e^x`, `10^x`, `x^y`, `x^2`, `x^3`, `2^x`.
  - Roots & Factorials: `√x`, `³√x`, `y√x`, `x!`.
  - Mathematical Constants: `π` (Pi), `e` (Euler's number), `Rand` (random number generator).
  - Inverse (`1/x`) and notation conversions.

### 2. Memory Operations (M-Suite)
- **`mc`** (Memory Clear): Resets the stored memory value to zero.
- **`m+`** (Memory Add): Adds the current result to memory.
- **`m-`** (Memory Subtract): Subtracts the current result from memory.
- **`mr`** (Memory Recall): Recalls the stored memory value directly into the active calculation.
- Stored persistently across app restarts.

### 3. Calculation History
- Automatic history logging for evaluated expressions and results.
- Tap-to-recall previous expressions or answers into the active input.
- Clear individual items or wipe complete history.
- Backed by Hive local storage.

### 4. Settings & Customization
- **Angle Units**: Toggle between Degrees (DEG) and Radians (RAD).
- **Display Precision**: Configure floating-point decimal places and scientific notation thresholds.
- **Feedback**: Enable or disable haptic vibration and tap audio effects.
- **Theme Adjustments**: Dark aesthetic with high contrast options.

---

## 🎨 Design & Aesthetics

SmartCalc follows an ultra-clean, modern dark UI inspired by classic iOS calculator ergonomics:

| Element | Hex Color | Description |
| :--- | :--- | :--- |
| **Canvas Background** | `#000000` | Pure deep black canvas |
| **Digit Keys** | `#333333` | Neutral dark grey circular buttons |
| **Scientific Keys** | `#1C1C1C` | Deep graphite keys for extended operations |
| **Function Keys** | `#A5A5A5` | Soft light grey keys (`AC`, `+/-`, `%`) with dark text |
| **Operator Keys** | `#FF9500` | Vibrant orange accent for core arithmetic (`÷`, `×`, `−`, `+`, `=`) |
| **Primary Text** | `#FFFFFF` | Crisp high-legibility display text |

- **Adaptive Dynamic Display**: Auto-shrinking font sizes for long numbers to prevent truncation or overflow.
- **Responsive Geometry**: Standard 4-column grid in portrait mode; smoothly expands to 10-column layout in landscape without jarring arithmetic position shifts.
- **Minimum 48×48 dp Touch Targets**: Ergonomic hit areas adhering to Google Material accessibility standards.

---

## 🏗 Architecture & Tech Stack

SmartCalc follows a **Feature-First Layered Architecture**:

```text
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                    │
│   (Flutter Widgets, Responsive Keypads, Display Text)   │
└────────────────────────────┬────────────────────────────┘
                             │ Dispatches UI Intents
┌────────────────────────────▼────────────────────────────┐
│                    Application Layer                    │
│      (Riverpod StateNotifier / Notifier Providers)      │
└────────────────────────────┬────────────────────────────┘
                             │ Evaluates Expressions / Commands
┌────────────────────────────▼────────────────────────────┐
│                      Domain Layer                       │
│    (Pure-Dart Tokenizer, AST Parser, Math Evaluator)    │
└────────────────────────────┬────────────────────────────┘
                             │ Persists State / Settings
┌────────────────────────────▼────────────────────────────┐
│                    Core & Data Layer                    │
│   (Hive Storage, Audio & Haptic Services, Theming)      │
└─────────────────────────────────────────────────────────┘
```

### Technology Highlights
- **Framework**: [Flutter](https://flutter.dev) (Dart `>=3.3.0 <4.0.0`)
- **State Management**: [Riverpod (`flutter_riverpod`)](https://riverpod.dev)
- **Local Persistence**: [Hive](https://docs.hivedb.dev/) & `hive_flutter`
- **Decimal Precision**: [`decimal`](https://pub.dev/packages/decimal)
- **Typography & Sounds**: `google_fonts`, `just_audio`
- **Testing**: `flutter_test`, `mocktail`, `integration_test`

---

## 📂 Project Structure

```text
smartcalc/
├── android/                   # Android native platform project & manifest configs
├── assets/
│   ├── icon.jpg               # App launcher icon source
│   └── sounds/                # Keypad tap sound effects
├── docs/                      # Supplemental documentation & guides
├── lib/
│   ├── main.dart              # Application entry point & service initialization
│   ├── app/
│   │   ├── app.dart           # MaterialApp configuration & root shell
│   │   └── theme.dart         # Colors, typography, and button theme tokens
│   ├── core/
│   │   ├── storage/           # Hive database service & type adapters
│   │   ├── utils/             # Formatters, audio & haptics controllers
│   │   └── widgets/           # Shared UI components (Display, CalcButton)
│   └── features/
│       ├── calculator/        # Calculator engine, AST parser, keypad layouts
│       │   ├── application/   # CalculatorController & provider state
│       │   ├── domain/        # ExpressionTokenizer, Parser, Evaluator, Token models
│       │   └── presentation/  # PortraitKeypad, LandscapeKeypad, CalculatorScreen
│       ├── history/           # History logging, state, and drawer/sheet UI
│       ├── memory/            # Memory storage register (M+, M-, MR, MC)
│       └── settings/          # Angle mode, sound/haptic toggles, precision settings
├── test/
│   ├── unit/                  # Math engine, tokenizer, parser unit tests
│   └── widget/                # Keypad interaction & display widget tests
├── Architecture.md            # Deep dive on architectural design decisions
├── Design.md                  # Theme tokens, layout rules, and UI specifications
├── PRD.md                     # Product Requirements Document
├── Phases.md                  # Development roadmap and phased delivery plan
├── PLAY_CONSOLE_PUBLISHING_GUIDE.md # Play Store deployment checklist
└── pubspec.yaml               # Project dependencies and asset definitions
```

---

## ⚙️ Calculation Engine & Math Capabilities

The calculation engine is written in **pure Dart** with zero UI dependencies, ensuring testability and precision:

1. **Tokenization**: Lexical analysis splits raw input into numbers, operators, identifiers, and parenthesis tokens.
2. **Parsing (Recursive-Descent / Shunting-Yard)**: Converts infix expressions to Abstract Syntax Trees (AST) or Reverse Polish Notation (RPN), honoring operator precedence:
   - `Parentheses`: `( ... )`
   - `Functions & Postfix`: `sin`, `cos`, `ln`, `x!`
   - `Powers & Roots`: `^`, `√`
   - `Multiplication & Division`: `*`, `/`, `%`
   - `Addition & Subtraction`: `+`, `-`
3. **Evaluation**: Evaluates AST nodes with runtime context (such as active `AngleMode.deg` vs `AngleMode.rad`).
4. **Safe Error Handling**: Explicit domain errors for divide-by-zero, negative square roots, or invalid syntax, preventing silent mathematical corruption or unhandled app crashes.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.3.0 or higher)
- [Android Studio](https://developer.android.com/studio) / Android SDK (API 21+)
- VS Code or Android Studio with Flutter extensions

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Tarun9105/Calc.git
   cd Calc
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # Run on a connected Android device or emulator
   flutter run
   ```

### Running Code Generation
If modifying Hive models or type adapters:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Running Tests
Execute the full test suite (unit and widget tests):
```bash
flutter test
```

To run integration tests:
```bash
flutter test integration_test/
```

---

## 🛠 Configuration & Settings

Users can customize their experience through the in-app settings sheet:

- **Angle Mode**: Toggle between Degree (`DEG`) and Radian (`RAD`). Default is `DEG`.
- **Haptic Feedback**: Subtle vibration on valid key presses.
- **Keypad Audio**: Click sound feedback on tap.
- **Decimal Precision**: Configurable rounding precision (standard 8-12 decimal places).
- **History Retention**: Configurable limit for saved calculation history records.

---

## ♿ Accessibility & Performance

- **Screen Readers**: Full TalkBack semantic labels on all keypad buttons and calculation results.
- **Touch Targets**: Guaranteed minimum `48x48 dp` touch targets for all interactive elements.
- **Visual Clarity**: High-contrast text on dark backgrounds with explicit textual error states (never reliant on color alone).
- **Offline & Battery Efficient**: Zero background sync, minimal CPU footprint during math evaluation, instant wake-up.

---

## 🗺 Roadmap & Phases

- [x] **Phase 0: Planning & Repository Setup** — Product requirements, system architecture, base structure.
- [x] **Phase 1: Domain Engine Foundation** — Pure-Dart tokenizer, parser, scientific evaluation engine, unit test suite.
- [x] **Phase 2: App Shell & Portrait Calculator UI** — Theme tokens, iOS-styled portrait keypad, Riverpod integration.
- [x] **Phase 3: Scientific Landscape Mode** — Landscape responsive layout, extended scientific function pad.
- [x] **Phase 4: History & Memory Persistence** — Local Hive persistence for past calculations and M-suite values.
- [x] **Phase 5: Settings, Accessibility & Polish** — Angle modes, haptics, TalkBack support, precision settings.
- [x] **Phase 6: QA & Play Store Readiness** — Release signing, icon generation, reference math test verification.

---

## 📦 Publishing & Release

For details on building the release Android App Bundle (`.aab`), configuring signing keys, and Google Play Console requirements, refer to:
- [Google Play Console Publishing Guide](file:///f:/Dev/Projects/gittarun/Calc/PLAY_CONSOLE_PUBLISHING_GUIDE.md)
- [Privacy Policy](file:///f:/Dev/Projects/gittarun/Calc/PRIVACY_POLICY.md)

---

## 👤 Author & Credits

- **Developer**: Tarun Kushwah ([@Tarun9105](https://github.com/Tarun9105))
- **Architecture & Design**: Designed & engineered with clean Dart/Flutter architecture principles.
