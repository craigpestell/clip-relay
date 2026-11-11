# Android clipboard spike

Throwaway code for [decision 0001](../../docs/decisions/0001-viability.md). It answers one question: **can a notification button put text on the Android clipboard without opening an app?**

| | How the user copies | Where the code runs |
|---|---|---|
| A | Tap **Copy (A)** on the notification | `BroadcastReceiver`, with no UI |
| B | Tap **Copy (B)** | An invisible activity that copies, then closes |
| C | Tap the notification itself | Same as B |

Each variant shows a small result notification and adds a line to the log in the app. Android 13+ also shows its own "Copied" confirmation. Apps in the background can't read the clipboard back, so **paste into any app to confirm**.

## Get the APK

The **Android spike APK** GitHub Actions workflow builds it on every push to `spikes/android/`. Open the workflow run, download the `clipspike-debug-apk` artifact, unzip it, and install `app-debug.apk` on the phone. Allow "install unknown apps" for your browser or Files app when asked.

Or build it with Android Studio: open `spikes/android`, then Run.

## Results

| Variant | Phone, Android ver | Paste works? | Taps | Notes |
|---|---|---|---|---|
| A, app in background | | | | |
| A, app swiped away | | | | |
| A, phone locked | | | | |
| B | | | | |
| C | | | | |
