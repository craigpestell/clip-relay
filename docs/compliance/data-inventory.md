# Data inventory (pre-build)

Owner: `security-compliance`. Draft 2026-11-10, written for the viability decision. Nothing is built.

| Data | Where it would live | Who can see it | Kept for |
|---|---|---|---|
| Text the user sends | Encrypted on the computer, passed through the relay, decrypted only on the phone | Only the user's paired devices | Deleted from the relay on delivery, or after 24 hours if undelivered |
| Device push tokens (APNs, FCM) | Relay database | The relay | Until the device is unpaired |
| Pairing keys | On each device only (keychain / keystore) | The device | Until unpaired |

Requirements for any design:
- End-to-end encryption, with keys exchanged by scanning a QR code during pairing. The relay must never be able to read the text.
- Push payloads carry only the encrypted text, or an ID the phone uses to fetch it. Plain text never goes to Apple or Google push servers.
- On Android, mark the clip with `ClipDescription.EXTRA_IS_SENSITIVE` so the system hides the preview ([Android docs](https://developer.android.com/privacy-and-security/risks/secure-clipboard-handling)).
- No analytics event may contain the text.
- Store review: the privacy labels must say "data not linked to you". Check Apple's and Google's current rules before submitting.
