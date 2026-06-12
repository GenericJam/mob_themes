# Agent instructions

This repo is a mob STYLE PACKAGE (the MOB_STYLES.md lane, tokens-only
tier) — five theme modules + a four-field `priv/mob_style.exs`.
Conventions are mob's — read `~/code/mob/AGENTS.md` +
`~/code/mob/CLAUDE.md` first, and `~/code/mob/MOB_STYLES.md` for the
style manifest schema + implementation status.

Pre-commit checklist (same as mob):

```bash
mix test
mix format
mix credo --strict       # includes ExSlop + jump_credo_checks
```

Pure Elixir — no native code, hot-pushable. The pre-push hook
(`.githooks/pre-push`, activate via `git config core.hooksPath
.githooks`) runs format/credo/compile on every push and the full suite
when mix.exs changes.

Releases: mix.exs version bump on master triggers
`.github/workflows/release.yml` (tag + GitHub Release + Hex publish).
Do NOT bump versions without explicit permission.
