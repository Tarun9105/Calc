# Ultimate Google Play Console Publishing Guide
*Based on comprehensive Google Play Console Developer Help documentation.*

This guide covers everything you need to know to publish **SmartCalc scientific calculator** (`com.tarun.smartcalc`) to the Google Play Store, ensuring compliance with all policies, data safety requirements, and testing tracks.

## Phase 1: Preparation & Developer Account
1. **Developer Account:** Ensure you have registered for a Google Play Developer account ($25 one-time fee) and completed identity verification.
2. **Privacy Policy Hosting:** 
   - Google requires a public URL for your Privacy Policy.
   - You can host the `PRIVACY_POLICY.md` file (provided in this project) for free using **GitHub Pages**, **Google Sites**, or a service like **AppPrivacyPolicy.com**.
   - Copy the generated URL to use in the Play Console.

## Phase 2: Create the App
1. Go to the [Google Play Console](https://play.google.com/console).
2. Click **Create app**.
   - **App name:** SmartCalc scientific calculator
   - **Default language:** English (or your preferred language)
   - **App or game:** App
   - **Free or paid:** Free
   - **Declarations:** Accept Developer Program Policies and US export laws.

## Phase 3: "Set Up Your App" Tasks (App Content)
On the Dashboard, find the "Set up your app" section. You MUST complete all these tasks before publishing.

1. **Privacy Policy:** Paste the URL where you hosted your Privacy Policy.
2. **App Access/Sign-in Details:** Select "All functionality is available without restrictions" (SmartCalc doesn't require a login).
3. **Ads:** Select "No, my app does not contain ads" (unless you added AdMob).
4. **Content Rating:** 
   - Enter your email.
   - Category: Select **"All other app types"**.
   - Answer "No" to all questions regarding violence, sexuality, offensive language, controlled substances, etc.
   - Save and generate the rating (usually E for Everyone / PEGI 3).
5. **Target Audience and Content:** 
   - Select the exact target age groups: **13-15**, **16-17**, and **18 and over**. (Do NOT select under 13 to avoid strict Families policy requirements).
   - Appeal to children: No.
6. **News App:** Select "No".
7. **COVID-19 contact tracing:** Select "My app is not a publicly available COVID-19 contact tracing or status app."
8. **Data Safety:** 
   - Does your app collect or share any of the required user data types? -> **No** (SmartCalc processes everything locally).
   - Save and submit.
9. **Government Apps:** Select "No".
10. **Financial Features:** Select **"My app doesn't provide any financial features"**.
11. **Advertising ID:** 
    - Does your app use an advertising ID? -> **No** (Since you don't have Ads or AdMob integrated).

## Phase 3.5: Store Settings
Navigate to **Store presence -> Store settings**.
1. **App category:** 
   - **App or game:** App
   - **Category:** Select **"Productivity"**.
   - **Tags:** Click Manage tags and add **"Productivity"** and **"Tools"**.
2. **Store Listing contact details:** 
   - **Email address:** Enter your support email (e.g., `[EMAIL_ADDRESS]`).
   - You can leave Phone number and Website blank.
3. **External marketing:** 
   - Leave the box checked for **"Advertise my app outside Google Play"**.

## Phase 4: Store Listing
Navigate to **Grow -> Store presence -> Main store listing**.
1. **App Name:** SmartCalc scientific calculator (max 30 chars).
2. **Short description:** E.g., "A powerful and easy-to-use scientific calculator for your daily needs." (max 80 chars).
3. **Full description:** Detail the features of your app (history, scientific functions, etc.).
4. **Graphics:**
   - **App icon:** 512px by 512px (PNG or JPEG).
   - **Feature graphic:** 1024px by 500px (PNG or JPEG).
   - **Phone screenshots:** Upload 2 to 8 screenshots of your app in action.

## Phase 5: Testing Requirements (CRITICAL for New Personal Accounts)
*If you created a personal developer account after November 13, 2023, Google enforces strict testing requirements before you can publish to Production.*

1. **Internal Testing (Optional but recommended):** Release to up to 100 trusted testers.
2. **Closed Testing (Mandatory for new personal accounts):**
   - You MUST recruit at least **20 testers**.
   - These testers must be opted-in to your closed test and have the app installed for at least **14 continuous days**.
   - You must gather feedback and answer Google's questions about how you incorporated this feedback.
   - *If your account is older or an enterprise account, you can skip straight to Production.*

## Phase 6: Build and Upload
1. In your terminal, navigate to `f:\Dev\Projects\tarunSisodia\Internship\Calc`.
2. Build the release App Bundle:
   ```bash
   flutter build appbundle --release
   ```
3. Locate the `.aab` file at `build/app/outputs/bundle/release/app-release.aab`.
4. In Play Console, go to **Testing -> Closed testing** (or **Production** if eligible).
5. Click **Create new release**.
6. If this is your first release, Play Console will ask you to opt into **Play App Signing**. Click "Continue/Accept" to let Google manage your app signing key.
7. Upload your `app-release.aab` file.
8. Enter Release name (e.g., "1.0.0") and Release notes.
9. Click **Save** and then **Review release**.

## Phase 7: Rollout & Review
1. Address any warnings or errors on the review page. (Warnings are usually okay, Errors must be fixed).
2. Click **Start rollout**.
3. Your app will now be "In review." Review times can take anywhere from a few hours to 7 days for a new app.

## Maintenance and Updates
- To release an update, you must increment the `version: 1.0.0+1` in your `pubspec.yaml` (e.g., to `1.0.1+2`), run `flutter build appbundle --release` again, and upload the new `.aab` to a new release in the Play Console.
- Regularly check the **Policy status** tab in the Play Console to ensure you aren't violating any new Google policies.
