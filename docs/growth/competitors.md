# Competitors

Owner: `growth-lead`. Checked 2026-11-10. Adoption figures are store install bands or ratings, not active users.

| Product | Computer | Android | iPhone | Adoption | Price | Status | Where it falls short |
|---|---|---|---|---|---|---|---|
| Chrome shared clipboard ("Send text to your devices") | Chrome desktop | Chrome for Android | No | Built into Chrome | Free | **Removed from Chrome**; the enterprise policy now "has no effect" ([Chrome Enterprise](https://chromeenterprise.google/policies/shared-clipboard-enabled/)) | Gone. It never worked on iPhone, and it needed Chrome Sync on both ends ([gHacks, 2019](https://www.ghacks.net/2019/12/10/share-clipboard-content-between-desktop-and-mobile-chrome-versions/)) |
| Apple Universal Clipboard | Mac | No | Yes | Built into Apple devices | Free | Active | Apple-only: same Apple Account, devices nearby, Bluetooth, Wi-Fi and Handoff on ([Apple](https://support.apple.com/en-us/102430)) |
| Microsoft Phone Link / Link to Windows | Windows | Yes | Limited | 1B+ installs ([Play](https://play.google.com/store/apps/details?id=com.microsoft.appmanager)) | Free | Active | Copy and paste only works on certain Samsung, HONOR and Surface Duo phones (Play listing). Reviews from 2026 describe it hanging on "connecting" |
| Pushbullet | Browser extensions and desktop | Yes | Unconfirmed | 5M+ installs, ~190K reviews ([Play](https://play.google.com/store/apps/details?id=com.pushbullet.android)) | Free tier, paid Pro | Last updated Aug 2025 | Reviews call it fragile, and dislike the paywall on message limits |
| KDE Connect | Linux, Windows, macOS | Yes | Yes (iOS 15+) | 1M+ installs on Android ([Play](https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp)), 279 ratings on iOS ([App Store](https://apps.apple.com/us/app/kde-connect/id1580245991)) | Free, open source | Active in 2026 | Same local network only, setup trouble behind firewalls. iOS reviews say receiving from the computer is weak |
| Join by joaoapps | Windows app, browser | Yes | No native app | 100K+ installs ([Play](https://play.google.com/store/apps/details?id=com.joaomgcd.join)) | $4.99 one-time | Last updated Dec 2025 | No iPhone app, no Firefox support, unreliable notifications |
| LocalSend | Windows, macOS, Linux | Yes | Yes | Claims 35M+ downloads ([localsend.org](https://localsend.org), not verified in a store) | Free, open source | Active | Manual send over the local network; no clipboard and no notification copy |

Not yet checked: Clipt (OnePlus), ClipCascade, Paste, "send to phone" Chrome extensions, and Reddit demand threads.

## What this says

- **Demand is proven on Android.** Millions of people installed Pushbullet and KDE Connect, largely for this job.
- **The cross-ecosystem gap is real.** Nothing does "Windows or Chrome computer → iPhone, one tap to copy" well. Apple covers Mac→iPhone, Microsoft covers Windows→some Androids, and Google removed Chrome's own version.
- **The gap may exist because of iOS rules,** not because nobody tried. See the feasibility section of [0001-viability](../decisions/0001-viability.md).
