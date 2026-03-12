# OpenClaw Security Policy

## Core Rules
1. Never overwrite docs/index.html automatically.
2. Never modify docs/arena, docs/battle, docs/submit automatically.
3. Automation may only write JSON under docs/data.
4. All automated commits must go through guarded commit.
5. Scheduled jobs must be low frequency and bounded.
6. Never auto-delete user workspace files.
7. Never auto-run unknown downloaded scripts.
8. Any UI change requires explicit human approval.

## Allowed Write Paths
- docs/data/
- governor/logs/
- scripts/
- governor/

## Protected Paths
- docs/index.html
- docs/arena/
- docs/battle/
- docs/submit/
- .github/workflows/ (unless explicitly approved)

## Scheduling Limits
- test cycle: no more than every 15 minutes
- improvement planning: no more than every 30 minutes
- evolution cycle: no more than every 30 minutes
- battles: no more than every 60 minutes

## Safety Goals
- minimize token waste
- minimize file churn
- minimize antivirus false positives
- keep GitHub Pages stable
