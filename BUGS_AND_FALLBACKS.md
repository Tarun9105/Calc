# Bugs, Fallbacks, and Play Store Readiness Report

This document outlines the identified issues, potential bugs, and mandatory requirements to be addressed before the app is ready for the Play Store.

## 1. Business Logic & Math Engine Bugs

### 🛑 Implicit Multiplication
*   **Issue:** The parser does not support implicit multiplication.
*   **Examples:** `2(3)` should be `6`, `5pi` should be `15.707...`.
*   **Current Behavior:** Shows "Invalid expression".
*   **Priority:** High (Expected behavior for scientific calculators).

### 🛑 Scientific Function Input Logic
*   **Issue:** In `ScientificKeypad`, functions like `sin` wrap the entire current expression (e.g., `sin(2+3)`).
*   **Better Behavior:** The button should append `sin(` to the end of the current expression, allowing users to build complex formulas like `sin(30) + cos(30)`.
*   **Priority:** High.

### 🛑 Scientific Notation Support
*   **Issue:** Manual input of scientific notation (e.g., `1.5e10`) is not supported by the current `_parseNumber` logic in `CalculatorEngine`.
*   **Priority:** Medium.

### 🛑 Floating Point Precision
*   **Issue:** Using `double` for internal calculations leads to precision errors (e.g., `0.1 + 0.2 != 0.3`).
*   **Fix:** Migrate `CalculatorEngine` to use the `decimal` package (already in `pubspec.yaml`).
*   **Priority:** Medium.

---

## 2. UI/UX Fallbacks

### ⚠️ Data Persistence (CRITICAL)
*   **Issue:** Currently, `HistoryRepository` and `SettingsRepository` use `InMemory` implementations.
*   **Result:** All calculations, history, and settings (theme, precision, etc.) are LOST when the app is closed.
*   **Fix:** Implement these repositories using the `hive` package (already in `pubspec.yaml`).
*   **Priority:** Critical for a Play Store app.

### ⚠️ Expression Overflow
*   **Issue:** `CalculatorDisplay` uses `maxLines: 1` with `ellipsis`. Long expressions become unreadable and cannot be scrolled.
*   **Fix:** Implement a horizontal scrollable expression view or dynamic font sizing.
*   **Priority:** Medium.

### ⚠️ Localization (Decimal Separator)
*   **Issue:** The decimal separator `.` is hardcoded. Many regions use `,`.
*   **Fix:** Use `intl` package to format numbers based on the user's locale.
*   **Priority:** Low (for initial release), but High for global reach.

### ⚠️ Accessibility (Semantics)
*   **Issue:** Main display results and error messages lack proper `Semantics` tags.
*   **Fix:** Wrap display widgets in `Semantics` to provide clear feedback to TalkBack/VoiceOver users.
*   **Priority:** Medium.

---

## 3. Play Store Publishing Requirements (Mandatory)

### 🚨 Application ID
*   **Current:** `com.example.smartcalc`
*   **Required:** Must be a unique, production-grade ID (e.g., `com.tarun.smartcalc`). `com.example` is restricted or discouraged on Play Store.
*   **Files to change:** `android/app/build.gradle.kts`, `AndroidManifest.xml`.

### 🚨 Release Signing
*   **Issue:** `build.gradle.kts` uses `debug` signing for release builds.
*   **Requirement:** Generate a production Upload Key (JKS/Keystore) and configure it in `gradle.properties`.

### 🚨 App Icons & Splash Screen
*   **Issue:** Default Flutter assets are still present.
*   **Requirement:** Unique adaptive icons and a branded splash screen.

### 🚨 Data Safety & Privacy Policy
*   **Requirement:** Google Play requires a URL to a Privacy Policy and a completed Data Safety form even if no data is collected.

---

## 4. Code Quality & Testing

### 🧪 Missing Tests
*   **Issue:** The `test/` directory is missing or empty.
*   **Requirement:** 
    *   Unit tests for `CalculatorEngine` (edge cases like division by zero, factorial limits, etc.).
    *   Widget tests for keypad and display interactions.
*   **Priority:** High.
