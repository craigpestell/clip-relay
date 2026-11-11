# Project profile

Every role reads this file first. It holds everything specific to this project, so the role agents in company-kit stay generic. Keep it short and true to the code; `talent-lead` keeps it current.

## Product

- **Name:** clip-relay (working name)
- **What it is:** for people who move between a computer and a phone, a way to select or copy text on the computer and send it to the phone, where a notification offers to copy it to the phone's clipboard.
- **Owner:** the founder (Craig). Not billed work.
- **Stage:** idea, 0 users. The current job is a viability call. The founder's bar for "viable" is a decent number of users adopting the app; adoption, not revenue, is the test. The decision record proposes a concrete target for the founder to confirm.

## Stack

- None yet. No code is written until the viability decision says go. Candidates to evaluate: a Chrome/Edge extension or a desktop app on the computer side; native iOS and Android apps on the phone side; a push relay (APNs, FCM) with end-to-end encryption.
- Code map: none. Docs only, under `docs/`.

## Commands

| What | Command |
| --- | --- |
| Install | none |
| Dev server | none |
| Type-check and build | none |
| Tests | none |
| Browser tests | none |

## Hosting and deploys

- **Host:** none yet.
- **How a change reaches production:** none; nothing ships yet.
- **Rollback:** none.
- **Where secrets live:** none yet. When there are any, they go in GitHub secrets or the host's secret store, never in the repo, an issue, or a status entry.

## Dashboard

Entry in the founder's client-hub (Projects). Skill: `project-dashboard`.

- **Pages to test:** none: no public site.
- **Vercel project:** none
- **DigitalOcean:** none
- **Links:** `Repo | https://github.com/craigpestell/clip-relay`
- **Registered:** not yet: needs founder

## Rules every role keeps

- **Clipboard text is private.** People copy passwords, codes and addresses. Any design must keep the text unreadable to the relay server (end-to-end encrypted) and must not log or store it after delivery.
- **No product code before the decision.** The founder approved a feasibility spike on 2026-11-10. Throwaway spike code lives in `spikes/` and is never shipped. Product code waits until `docs/decisions/0001-viability.md` says go after the spike and the founder agrees.
- **Cite sources with the date checked** for every market, competitor or platform claim. Platform rules (especially iOS clipboard and notification limits) change; check them on the web, not from memory.

## Deploy gate

A change ships only when all of these hold:

- There is CI, and its required check is green on the exact commit. (No CI yet: nothing ships.)
- QA has verified it against the acceptance criteria.
- No role approves its own work.

## What only the founder approves

- Spending money, signing up for paid services, or changing the budget
- Publishing anything public, and contacting anyone outside the company (including surveys, posts, or ads to test demand)
- The go or no-go on building, and the adoption target that defines "viable"
- Developer program sign-ups (Apple, Google Play, Chrome Web Store) and store submissions

## Analytics

None yet. Decide in the launch plan; any analytics must never capture clipboard contents.
