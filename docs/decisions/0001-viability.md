# 0001 · Is clip-relay viable?

- **Status:** proposed, needs the founder's decision
- **Date:** 2026-11-10
- **Owner:** `product-lead`, with input from `growth-lead`, `engineering-lead`, `security-compliance` and `finance-lead`
- **Test (from the founder):** viable means a decent number of people adopt it.

## Verdict

**Conditional go: run a one-week technical spike on iPhone before building anything.**

The demand is real, and the best gap is iPhone users with a non-Mac computer. That same gap is the riskiest part to build, because iOS limits what apps can do with the clipboard in the background. If the iPhone experience turns out to be "tap the notification, the app opens, the text is copied", the product is still worth building. If it can't be smooth, the product becomes an Android-only rival to Pushbullet and KDE Connect, which is a much weaker position.

## Evidence

**Demand** ([competitors](../growth/competitors.md)): Pushbullet has 5M+ Android installs, KDE Connect 1M+ and Join 100K+, all doing roughly this job. Google built this exact feature into Chrome, then removed it. Apple and Microsoft each cover only their own ecosystem.

**Feasibility** (`engineering-lead`):

| Platform | Can a notification button copy the text? | Confidence |
|---|---|---|
| Chrome extension (computer) | Yes. A context-menu item "Send to phone" on selected text is standard extension work. | High |
| Android | Probably yes. Android 10+ restricts *reading* the clipboard from the background, and no doc found restricts *writing* ([Android 10 privacy](https://developer.android.com/about/versions/10/privacy/changes), [copy and paste guide](https://developer.android.com/develop/ui/views/touch-and-input/copy-paste)). KDE users report it can still write to the clipboard ([KDE bug 436329](https://bugs.kde.org/show_bug.cgi?id=436329)). | Medium, needs a device test |
| iPhone | Unknown. Apple bars background clipboard *reading* as policy ([Apple DTS](https://developer.apple.com/forums/thread/706761), [also](https://developer.apple.com/forums/thread/100501)). Writes from UI-less extensions have failed for developers ([forum](https://developer.apple.com/forums/thread/679587)). The safe fallback is a notification that opens the app, which copies and shows "Copied". Options to test: a background notification action, a notification content extension (long-press), and an App Intent or Control Center control. | Low, the main risk |

**Security** ([data inventory](../compliance/data-inventory.md)): end-to-end encryption is required and practical. The relay only ever sees ciphertext.

**Cost** (`finance-lead`, est.; prices from memory, check before paying): Apple Developer Program about $99/yr, Google Play about $25 once, Chrome Web Store about $5 once. Pushes go through APNs and FCM at no charge. A small relay fits a free serverless tier at launch scale. The main cost is build time.

## Spike results so far (2026-11-13)

- **iPhone Simulator** (iOS 27.3): all five variants wrote to the clipboard. The best result is **variant A**: two taps (long-press the notification, tap Copy) with the app staying closed. It worked even after the app was force-quit, because iOS launched it in the background to run the copy. Variant D, a Copy button in the expanded notification, also works without opening the app. See [spikes/ios](../../spikes/ios/README.md).
- **Still needed:** a real iPhone with a real push, because the Simulator skips the device's clipboard restrictions. Also the Android test on the founder's phone.
- **Reading:** if a real iPhone matches, the main technical risk is gone and the iPhone experience is two taps with no app switch.

## Proposed adoption target

**1,000 weekly active users within 3 months of a public launch, and 5,000 within 6 months.** Weekly active means at least one text sent in the week. Below 300 at 3 months, stop or pivot. This is a proposal; the founder sets the real number.

## Next steps if the founder agrees

1. **Spike (1 week, `engineering-lead`):** a bare Chrome extension, a relay and an iPhone test app. Measure the number of taps from "Send" to "text on the iPhone clipboard" for each iOS option, then repeat on Android.
2. **Demand check (in parallel, `growth-lead`):** count recent Reddit and forum threads asking for this, and check search volume. Publish nothing without approval.
3. **Decide again:** if iPhone takes one or two taps with no app switch, or one tap with an acceptable brief app open, write the MVP spec (Chrome extension + iPhone + Android, pairing by QR code, text only). Otherwise, revisit.

## Open questions

- Is Android-only worth building if iPhone fails? (Recommendation: no, the market already has free options.)
- Should the computer side also have a desktop app for system-wide copy, or only the Chrome extension at first? (Recommendation: Chrome extension first.)
