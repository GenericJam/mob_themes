# mob_themes — Agent Instructions

**Read [`AGENTS.md`](AGENTS.md) first**, then [`~/code/mob/AGENTS.md`](../mob/AGENTS.md) for the system view, and `~/code/mob/MOB_STYLES.md` for the style-manifest schema and tier structure. Together they cover the five themes, the token-only tier, and the cross-repo work with mob / mob_mishka. This file goes deeper on Claude Code-specific workflow detail.

> **Keep AGENTS.md up to date** when you add a theme, retune a palette, or hit a gotcha. Out-of-date guidance there causes wrong decisions downstream — fix it in the same commit.

## What this repo is

A Mob **style-package** (MOB_STYLES.md lane, token-only tier): five theme modules — Obsidian (default), ObsidianGlass, Citrus, Birch, Material3 — plus a four-field `priv/mob_style.exs`. Activated via `config :mob, :styles, [:mob_themes]` (NOT `:plugins`). Pure Elixir, no native code, hot-pushable.

## Pre-commit checklist

Before committing, run all in this order:

```bash
mix format
mix credo --strict                  # includes ExSlop + jump_credo_checks
mix compile --warnings-as-errors
mix test
```

Pre-push hook (`.githooks/pre-push`) adds format + credo strict + compile on every push and the full suite when `mix.exs` changes. Activate once per clone:

```bash
git config core.hooksPath .githooks
```

Pure-Elixir package — no native code to check, no device build required for merge. Visual verification is still worth doing: install into a host, `config :mob, :styles, [:mob_themes]`, `Mob.Theme.set/1` through all five and confirm each renders without missing-token warnings.

### Tests are part of the change

For mob_themes specifically:

* Adding a theme = adding a test that asserts `theme/0` returns a `Mob.Theme.t()` with every token the token set expects, plus adding it to `MobThemes.all/0`.
* Retuning a palette = the change is usually small enough that a test would only restate it; visual diff on a host is the real signal.
* Any manifest change to `priv/mob_style.exs` needs a validator test — the four-field minimum is deliberate.

### Adversarial review — before every non-trivial commit

Spawn a subagent, point it at the diff. Especially:

* **Missing tokens.** Did you drop a token a widget in mob_mishka or mob core reads? Grep for token names in both repos before shipping a new theme.
* **Style-package vs plugin drift.** If a change wants to put something under `config :mob, :plugins` or `priv/mob_plugin.exs`, it's in the wrong repo — themes are `:styles` + `priv/mob_style.exs`.
* **Material3 over-promise.** Material3 in this package is the token-only baseline; do not claim pixel-perfect M3.

Skip only for: formatting, a typo, a version bump.

## Release flow

Canonical process in [`~/code/mob/RELEASE.md`](../mob/RELEASE.md). mob_themes specifics:

* `@version` in `mix.exs` is the trigger. Push to master, GH Actions handles tag / GitHub release / Hex publish, signed with the shared mob first-party key.
* Hot-pushable, no device rebuild needed — but visual verification on both light and dark theme against a real host before bumping is still the right call.
