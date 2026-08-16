# SmartCalc - Flutter & Android Gradle Build Guide

This comprehensive guide details the Android build system configuration for **SmartCalc**, explaining how Gradle is structured in Flutter, the essential commands for building and diagnosing the app, and a step-by-step self-troubleshooting reference.

---

## 1. Overview & Project Status

### Why Initial Build Failed
When running `flutter build apk` on a freshly cloned repository, the build initially failed because:
1. The `android/` directory was listed in `.gitignore` and was not present in the workspace.
2. Flutter could not locate `android/app/build.gradle` (or `build.gradle.kts`).

### Resolution Performed
1. Executed `flutter create . --platforms=android --org com.example` to regenerate the Android platform scaffolding with modern Kotlin DSL (`.gradle.kts`).
2. Cleaned up template artifacts (`test/widget_test.dart`) to ensure `flutter test` passed (18/18 tests pass).
3. Ran `flutter build apk`, which automatically resolved Android SDK Platform 36, NDK, and CMake dependencies, successfully compiling the release binary.

**Generated APK Location:**
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 2. Android Gradle Configuration Anatomy

Modern Flutter projects use **Gradle Kotlin DSL (`.gradle.kts`)** or Groovy (`.gradle`). Here is the file-by-file breakdown of what each file does in `android/`:

```
android/
├── app/
│   ├── build.gradle.kts          <-- App-level module configuration (SDKs, versioning, signing)
│   └── src/
│       └── main/
│           └── AndroidManifest.xml <-- App permissions, orientation, theme, package
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties <-- Declares the Gradle version used
├── build.gradle.kts              <-- Root project build script (repositories, build outputs)
├── settings.gradle.kts           <-- Plugin management, repositories, AGP/Kotlin versions
├── gradle.properties             <-- JVM flags, AndroidX toggles, Kotlin memory settings
└── local.properties              <-- Local SDK paths (auto-generated, gitignored)
```

### A. `android/settings.gradle.kts`
**Purpose:** Sets up repository sources and tells Gradle which plugins (Android Gradle Plugin, Kotlin, Flutter) to load before any subproject is evaluated.
```kotlin
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
}

include(":app")
```
- `id("com.android.application")`: The Android Gradle Plugin (AGP) version.
- `id("org.jetbrains.kotlin.android")`: The Kotlin compiler plugin version.

---

### B. `android/build.gradle.kts` (Root Project)
**Purpose:** Configures global repositories and routes build artifacts from `android/app/build` up to the top-level `build/` directory for Flutter consistency.
```kotlin
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
```

---

### C. `android/app/build.gradle.kts` (App Module)
**Purpose:** Configures Android-specific compilation targets, minimum SDK support, packaging versions, and signing configurations.
```kotlin
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smartcalc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.smartcalc"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Debug key signing for local testing (change for Google Play release)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
```

#### Key Fields to Understand:
- **`namespace` / `applicationId`**: Unique package name of your app on Android / Play Store (e.g., `com.company.smartcalc`).
- **`minSdk`**: The minimum Android API level required to run the app (defaults to Flutter's recommendation, API 21+).
- **`targetSdk`**: The Android API level the app is tested against and designed for.
- **`compileSdk`**: The SDK version used to compile Java/Kotlin code.
- **`JavaVersion.VERSION_17` & `JVM_17`**: Specifies Java 17 bytecode target (required by modern AGP 8.x/9.x).

---

### D. `android/gradle/wrapper/gradle-wrapper.properties`
**Purpose:** Pinpoints the exact Gradle daemon version downloaded and used by the build tool.
```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-9.3.1-all.zip
```

---

## 3. Essential CLI Commands Reference

### A. Flutter CLI Commands

| Command | Purpose | When to Use |
| :--- | :--- | :--- |
| `flutter doctor -v` | Comprehensive environment diagnostics | First step whenever a build or tooling error occurs. |
| `flutter doctor --android-licenses` | Accepts required Android SDK licenses | When Gradle fails with "license not accepted". |
| `flutter create . --platforms=android` | Generates missing `android/` scaffolding | When the `android/` directory is missing or corrupted. |
| `flutter clean` | Deletes `build/` and cached compilation outputs | When builds fail mysteriously or after dependency upgrades. |
| `flutter pub get` | Resolves and downloads Dart packages | After modifying `pubspec.yaml`. |
| `flutter build apk` | Compiles a single "fat" release APK | For general testing/sideloading onto Android devices. |
| `flutter build apk --split-per-abi` | Builds individual APKs per CPU architecture | Produces much smaller APKs (`arm64-v8a`, `armeabi-v7a`, `x86_64`). |
| `flutter build apk --debug` | Builds a debug APK quickly without optimization | Fast builds for device testing. |
| `flutter build appbundle` | Generates `.aab` (Android App Bundle) | For publishing to the Google Play Console. |
| `flutter run -d <device_id>` | Launches the app in debug mode with hot reload | Active development and UI testing. |
| `flutter test` | Executes all unit and widget tests | Validating logic before building releases. |
| `flutter analyze` | Runs Dart static analysis | Catching type errors, unused code, or lint violations. |

---

### B. Direct Gradle Commands (`android/` directory)

You can run Gradle directly inside the `android/` directory using the Gradle wrapper (`.\gradlew` on Windows or `./gradlew` on macOS/Linux):

```powershell
cd android

# 1. Clean Gradle build cache
.\gradlew clean

# 2. Build Release APK directly
.\gradlew assembleRelease

# 3. Build Debug APK directly
.\gradlew assembleDebug

# 4. View detailed dependency tree (great for resolving version conflicts)
.\gradlew app:dependencies

# 5. Run build with stacktrace when investigating unknown build failures
.\gradlew assembleRelease --stacktrace

# 6. Run build with full debug logs
.\gradlew assembleRelease --info
```

---

## 4. Self-Troubleshooting & Problem Diagnosis

Follow this flowchart-style checklist whenever encountering build issues.

### 1. "Flutter failed to read file ... build.gradle" or Missing Android Platform
* **Cause:** The `android/` directory was deleted or not committed to git.
* **Fix:**
  ```powershell
  flutter create . --platforms=android --org com.example
  ```

---

### 2. "Android license status unknown" / "Licenses not accepted"
* **Cause:** Android SDK components (platforms, NDK, build-tools) require license acceptance.
* **Fix:**
  ```powershell
  flutter doctor --android-licenses
  ```
  Press `y` and `Enter` for all prompts.

---

### 3. "Java version mismatch" or "Unsupported class file major version"
* **Cause:** AGP 8+ / 9+ requires **JDK 17** or **JDK 21**. If your system `JAVA_HOME` points to Java 8 or Java 11, Gradle fails.
* **Fix:**
  1. Verify Java version: `java -version`
  2. Set `JAVA_HOME` environment variable to a JDK 17+ installation (or Android Studio's bundled JBR at `C:\Program Files\Android\Android Studio\jbr`).
  3. Ensure `compileOptions` in `android/app/build.gradle.kts` matches Java 17:
     ```kotlin
     compileOptions {
         sourceCompatibility = JavaVersion.VERSION_17
         targetCompatibility = JavaVersion.VERSION_17
     }
     ```

---

### 4. "minSdkVersion X cannot be smaller than version Y"
* **Cause:** A plugin added to `pubspec.yaml` requires a higher Android API level than default.
* **Fix:**
  Open `android/app/build.gradle.kts` and explicitly specify the required version:
  ```kotlin
  defaultConfig {
      minSdk = 23 // Or whichever version is required
  }
  ```

---

### 5. "Duplicate class found" / Dependency Version Conflicts
* **Cause:** Two plugins depend on different versions of the same native Android library.
* **Fix:**
  1. Run dependency tree inspection:
     ```powershell
     cd android
     .\gradlew app:dependencies
     ```
  2. Locate the conflicting library and enforce a unified version in `android/app/build.gradle.kts`:
     ```kotlin
     configurations.all {
         resolutionStrategy {
             force("com.google.android.gms:play-services-base:18.0.1")
         }
     }
     ```

---

### 6. Outdated Build Cache or "Stale Artifacts"
* **Symptoms:** Code changes aren't reflected, or weird missing class errors appear after switching branches.
* **Fix (Full Nuclear Clean):**
  ```powershell
  flutter clean
  Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
  Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
  flutter pub get
  flutter build apk --debug
  ```

---

### 7. How to Inspect Native Crash Logs on Device
To read real-time Android logs (including native crashes or plugin failures):
```powershell
# View filtered Flutter / Android logcat output:
flutter logs

# Or directly via Android Debug Bridge (ADB):
adb logcat -s flutter:V *:E
```

---

## 5. Summary Cheat-Sheet

| Objective | Command |
| :--- | :--- |
| **Clean Everything** | `flutter clean; flutter pub get` |
| **Run Unit & Widget Tests** | `flutter test` |
| **Verify Environment** | `flutter doctor -v` |
| **Build Test Release APK** | `flutter build apk` |
| **Build Optimized Split APKs** | `flutter build apk --split-per-abi` |
| **Build Production App Bundle** | `flutter build appbundle` |
| **Debug Gradle Failure** | `cd android; .\gradlew assembleRelease --stacktrace` |
