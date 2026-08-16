# Release QA & Pre-launch Checklist

## 1. Functional Testing & Validation
- [x] Pass 100% of reference math validation unit tests (`test/unit/reference_math_validation_test.dart`).
- [ ] Pass all integration tests in `integration_test/app_flow_test.dart` (Basic math, Scientific math, History, Memory, Settings).
- [ ] Verify landscape mode rotation preserves mathematical state.
- [ ] Verify handling of extremely large numbers (ensure `overflow` displays instead of crashing).
- [ ] Verify division by zero and invalid domain errors are handled gracefully (e.g., `asin(2)`).

## 2. Accessibility & Usability (TalkBack)
- [ ] Launch app with Android TalkBack enabled.
- [ ] Ensure every button announces its semantic label clearly (e.g., "Plus", "Equals", "Nine", "Clear All").
- [ ] Adjust device text scaling to 200% and verify the calculator display auto-shrinks properly without clipping.

## 3. Performance Profiling
- [ ] Profile cold start time on a physical mid-tier device (target < 1.5s).
- [ ] Verify 60fps/120fps smooth animations during theme toggles and orientation changes.
- [ ] Ensure memory consumption remains stable after extensive history population.

## 4. Build & Signing Prep
- [ ] Run `flutter clean` to ensure a clean build environment.
- [ ] Run `flutter pub get` and verify dependencies.
- [ ] Build Release AAB: `flutter build appbundle --release`.
- [ ] Verify ProGuard/R8 obfuscation didn't break core logic.
- [ ] Sign the AAB with the production release keystore before uploading to Play Console.

## 5. Store Listing Assets
- [ ] High-Res Icon (512x512).
- [ ] Feature Graphic (1024x500).
- [ ] At least 4 screenshots (Portrait Math, Landscape Scientific, History Panel, Settings Panel).
- [ ] Review `docs/play_store_listing.md` for accuracy.
