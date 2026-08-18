# Android Build & Signing Guide

This guide covers all commands needed to build, sign, debug, and manage the Android app via Flutter and Gradle.

---

## 1. Generate the Keystore

Run once to create the signing keystore:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be prompted for a password and identification info. Keep it safe.

---

## 2. Configure key.properties

Ensure `android/key.properties` exists with your credentials:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=upload-keystore.jks
```

> **Note**: Never commit `key.properties` or `upload-keystore.jks` to version control.

---

## 3. Flutter Build Commands

### Signed APK (single fat APK)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs per ABI (smaller, recommended for Play Store)
```bash
flutter build apk --split-per-abi
```
Output:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### App Bundle — AAB (required for Play Store submissions)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### Debug build (no signing required)
```bash
flutter build apk --debug
```

### Profile build (performance testing)
```bash
flutter build apk --profile
```

### Build with verbose output (useful for diagnosing errors)
```bash
flutter build apk --release -v
```

---

## 4. Gradle Commands (run from `android/` directory)

### Assemble release APK via Gradle directly
```bash
./gradlew assembleRelease
```

### Assemble debug APK via Gradle directly
```bash
./gradlew assembleDebug
```

### Build App Bundle via Gradle directly
```bash
./gradlew bundleRelease
```

### Run all unit tests
```bash
./gradlew test
```

### Run instrumented (on-device) tests
```bash
./gradlew connectedAndroidTest
```

### List all available Gradle tasks
```bash
./gradlew tasks
```

### Check dependency tree
```bash
./gradlew app:dependencies
```

### Check for dependency conflicts
```bash
./gradlew app:dependencyInsight --dependency <library-name>
```

### Lint check
```bash
./gradlew lint
```
Report: `android/app/build/reports/lint-results-debug.html`

### Sign verification — confirm APK signing info
```bash
./gradlew signingReport
```

---

## 5. Cache & Build Cleanup

### Clean Flutter build artifacts
```bash
flutter clean
```

### Clean Gradle build cache (android/ directory)
```bash
./gradlew clean
```

### Clean + rebuild in one step (Flutter)
```bash
flutter clean && flutter pub get && flutter build apk --release
```

### Invalidate Gradle global cache (fixes corrupt caches)
```bash
./gradlew --refresh-dependencies
```

### Delete all Gradle caches manually (Windows PowerShell)
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches"
```

---

## 6. Gradle Daemon Management

### Check running Gradle daemons
```bash
./gradlew --status
```

### Stop all running Gradle daemons
```bash
./gradlew --stop
```

### Run build without daemon (useful for CI)
```bash
./gradlew assembleRelease --no-daemon
```

### Run with increased logging
```bash
./gradlew assembleRelease --info
```

### Run with full debug output
```bash
./gradlew assembleRelease --debug
```

### Profile Gradle build performance
```bash
./gradlew assembleRelease --profile
```
Report: `android/build/reports/profile/`

---

## 7. JVM / Performance Tuning

These settings live in `android/gradle.properties`:

```properties
# Heap size for Gradle daemon
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError --enable-native-access=ALL-UNNAMED

# Enable parallel builds
org.gradle.parallel=true

# Enable build caching
org.gradle.caching=true

# Enable configuration cache (Gradle 7+)
org.gradle.configuration-cache=true
```

---

## 8. Install APK to Connected Device

```bash
# Install release APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Install and replace existing app
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Install to specific device (if multiple connected)
adb -s <device-id> install build/app/outputs/flutter-apk/app-release.apk

# List connected devices
adb devices
```

---

## 9. Useful Flutter Doctor & Info

```bash
# Check Flutter environment health
flutter doctor -v

# List connected devices
flutter devices

# Check outdated packages
flutter pub outdated

# Upgrade all packages
flutter pub upgrade

# Get dependencies
flutter pub get
```
