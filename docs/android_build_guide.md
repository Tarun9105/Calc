# Android Build & Signing Guide

This guide provides the necessary commands and steps to generate a signed Android APK and App Bundle (AAB) for the Google Play Store.

## 1. Generate the Keystore

If you ever need to generate a new signing keystore, run the following command in the root of the project:

`ash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
``n
You will be prompted to enter a password and answer a few identification questions. Remember the password, as you will need it for the next step.

## 2. Configure key.properties

Ensure you have an ndroid/key.properties file with your keystore credentials:

`properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=upload-keystore.jks
``n
> **Note**: Never commit key.properties or upload-keystore.jks to version control.

## 3. Build the Signed APK

To build a standard signed APK (usually for direct sharing or manual testing):

`ash
flutter build apk --release
``n
The generated APK will be located at:
uild/app/outputs/flutter-apk/app-release.apk`n
## 4. Build the Signed App Bundle (Play Store)

The Google Play Store requires an Android App Bundle (.aab) for new app submissions.

`ash
flutter build appbundle --release
``n
The generated App Bundle will be located at:
uild/app/outputs/bundle/release/app-release.aab`n
