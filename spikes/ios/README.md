# iPhone clipboard spike

Throwaway code. It answers one question from [decision 0001](../../docs/decisions/0001-viability.md): **can a notification put text on the iPhone clipboard, and how many taps does it take?**

It uses local notifications and simulated pushes, so no paid Apple Developer account and no server are needed.

## Variants

| | How the user copies | Where the code runs |
|---|---|---|
| A | Long-press the notification, tap **Copy (A: background)**. The app stays closed | App, launched in the background |
| B | Long-press, tap **Copy (B: opens app)** | App, brought to the foreground |
| C | Tap the notification itself | App, brought to the foreground |
| D | Long-press a "D" notification, tap the **Copy** button inside it | Notification content extension |
| E | Tap the **ClipSpike copy** control in Control Center (iOS 18+) | Widget extension App Intent |

Each variant checks `UIPasteboard.changeCount` before and after writing. That reports **WRITE OK** or **WRITE FAILED** without triggering the paste prompt. Always confirm by pasting into Notes too.

## Build

```sh
brew install xcodegen        # once
cd spikes/ios
xcodegen generate
open ClipSpike.xcodeproj
```

- **Simulator:** pick any iPhone simulator running iOS 18 or later and press Run.
- **A real iPhone:** plug it into the Mac and set `BASE_BUNDLE_ID` to something unique in `project.yml`. Set `DEVELOPMENT_TEAM` to your team ID; a free personal team works. Run `xcodegen generate` again. On the phone, turn on Developer Mode, then trust the developer under Settings → General → VPN & Device Management. Free provisioning expires after 7 days.

## Run the tests

1. Open the app and tap **Allow notifications**.
2. Tap a "Send a test notification" button, then go to the Home Screen within 5 seconds.
3. Try the variant, then paste into Notes.
4. Repeat A after force-quitting the app (swipe it away in the app switcher), since a real push usually arrives when the app isn't running.
5. On the Simulator you can also send a fake push. With the app running or not:
   `xcrun simctl push booted com.example.clipspike push-A-B.apns` (or `push-D.apns`).
6. For E, add the control in Control Center (edit → Add a Control → ClipSpike copy).
7. Open the app and read the log in **Results**. Variant D shows its result inside the notification; D and E also log to Console.app (search "ClipSpike").

## Results

| Variant | Simulator (iOS ver) | iPhone (model, iOS ver) | Paste in Notes works? | Taps | Notes |
|---|---|---|---|---|---|
| A, app in background | OK (iOS 27.3 sim, iPhone 18 Pro) | | Yes | 2 (long-press, Copy) | App stays in background |
| A, app force-quit | OK | | Yes | 2 | iOS launched the app in the background to copy |
| B | OK | | Yes | 2 | App comes to the front |
| C | OK | | Yes | 1 | App opens |
| D | OK, after linking UserNotificationsUI (#6) | | Yes | 2 (expand, Copy) | App doesn't open |
| E | OK | | Yes | 1 from Control Center | Copies a fixed string; control must be added once |

Simulator run 2026-11-13, Xcode-beta 27.3 (27C5020n). The Simulator applies none of a real iPhone's paste prompts or restrictions, so this only shows the code works.
The Simulator is only a first signal. The verdict needs at least one real iPhone.
