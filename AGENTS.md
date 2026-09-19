# AGENTS.md — orientation for AI agents working on mob_themes

You're in **mob_themes**, a Mob **style-package**: one package, five preset visual looks. Obsidian (deep-violet dark, the boot default), ObsidianGlass (obsidian with translucent depth), Citrus (warm charcoal with lime accent), Birch (light, paper-warm), and Material3 (M3 baseline palette). All five are token-only — they set the palette / typography tokens that `mob_mishka` and core widgets read; they do not ship components.

**Also read [`~/code/mob/AGENTS.md`](../mob/AGENTS.md)** and **`~/code/mob/MOB_STYLES.md`** for the style-manifest schema, tier structure, and how `Mob.Theme.build/1` composes tokens. This file is mob_themes-specific.

> **Keep this file current.** When you add a theme, retune a palette, or hit a gotcha that would trip the next agent, fix it here in the same commit.

## What mob_themes is, in one paragraph

Five modules under `MobThemes.*`, each exporting a `theme/0 :: Mob.Theme.t()` built with `Mob.Theme.build/1`. The package's `priv/mob_style.exs` (a **style** manifest, not a plugin manifest) declares the boot default (`MobThemes.Obsidian`). The host opts in with `config :mob, :styles, [:mob_themes]` and optionally `config :mob, :default_style, :mob_themes`. Any theme can be switched live at runtime with `Mob.Theme.set/1` — either the module (`Mob.Theme.set(MobThemes.Citrus)`) or a `{module, overrides}` tuple (`Mob.Theme.set({MobThemes.Birch, primary: :emerald_500})`). Pure Elixir, no native code, hot-pushable.

## What mob_themes is NOT

* **Not a component kit.** [mob_mishka](https://hexdocs.pm/mob_mishka) is the component kit; mob_themes swaps the *tokens* that mob_mishka + core widgets read. If a change needs a new widget or a widget layout tweak, that lives in mob_mishka, not here.
* **Not a plugin.** This is a **style-package**, activated via `config :mob, :styles`, NOT `config :mob, :plugins`. The manifest file is `priv/mob_style.exs`, NOT `priv/mob_plugin.exs`. `plugin_spec_version` / `nifs` / `screens` do not apply here.
* **Not the native-override tier.** Material3 pixel-perfect (surface elevations, ripple, precise M3 typography) needs the native-override style tier, which isn't built yet — Material3 in this package is the token-only baseline. Do not promise it looks identical to Android's M3.
* **Not mob core's neutral baseline.** mob core keeps its own light/dark/adaptive as a neutral zero-config default; mob_themes is what you install when you want *these five looks specifically*.

## Anatomy of the package

* `lib/mob_themes.ex` — `MobThemes.all/0` (list of the five modules) + top-level moduledoc.
* `lib/mob_themes/obsidian.ex` — the package default; primary `:violet_600`, near-black surfaces.
* `lib/mob_themes/obsidian_glass.ex` — obsidian with translucent depth.
* `lib/mob_themes/citrus.ex` — warm charcoal + lime accent.
* `lib/mob_themes/birch.ex` — light, paper-warm.
* `lib/mob_themes/material3.ex` — M3 baseline (tokens only; see NOT above).
* `priv/mob_style.exs` — the style manifest. Four fields: `:name`, `:mob_version`, `:style_spec_version` (currently `1`), `:description`, `:theme` (the boot default). No `plugin_spec_version`, no `nifs`, no `screens`.
* No `src/`, no `priv/native/`, no `decisions/` — everything here is pure Elixir tokens.

## Cross-repo work

**mob (framework):** `Mob.Theme.build/1`, `Mob.Theme.set/1`, and the style-manifest validator live in mob core. If the manifest schema evolves (e.g. a richer multi-theme shape with `:default_style` selecting named variants), `priv/mob_style.exs` is what updates here. The four-field minimum is deliberate — richer shapes can come later without breaking this package. See [`~/code/mob/AGENTS.md`](../mob/AGENTS.md) + `~/code/mob/MOB_STYLES.md`.

**mob_mishka:** the reader of these tokens. If a widget in mob_mishka references a token this package doesn't set, fix it in mob_mishka OR add the token here (both sides must agree). Do not silently paper over a missing token with a fallback color — it hides the drift.

## Testing

Elixir suite (validator + `all/0` shape + palette sanity checks):

```bash
mix deps.get
mix test
```

Visual verification: install into a host with `config :mob, :styles, [:mob_themes]`, boot the app, then cycle:

```elixir
Mob.Theme.set(MobThemes.Obsidian)
Mob.Theme.set(MobThemes.ObsidianGlass)
Mob.Theme.set(MobThemes.Citrus)
Mob.Theme.set(MobThemes.Birch)
Mob.Theme.set(MobThemes.Material3)
```

Confirm each renders without color-token warnings and that overrides via `{module, [primary: ...]}` land correctly. Live switching needs no rebuild — themes are hot-pushable.

## The pre-empt-failure rules that matter here

1. **Style-package, not plugin.** If you ever find yourself editing `priv/mob_plugin.exs`, you're in the wrong repo — themes live in `priv/mob_style.exs` and go under `config :mob, :styles`. Wiring under `:plugins` will fail validation.
2. **Token-only tier — do not add a native override.** Material3 pixel-perfect needs the native-override tier that doesn't exist yet. If you feel the urge to reach for a native file, stop; the tier is a mob-core question, not a mob_themes one.
3. **Keep the four-field manifest minimum.** The style-spec-v1 shape is deliberately small. Extra fields will validate today but lock in shape before mob core has decided on richer variants.
4. **Every theme sets the same token set.** `all/0` themes must be interchangeable at `Mob.Theme.set/1`. Missing a token that a widget reads is a silent breakage — grep `mob_mishka` + mob core for token consumers before shipping a new theme.

## Pre-commit + release

Standard mob gate (pure Elixir — no zig / clang-format):

```bash
mix format
mix credo --strict
mix compile --warnings-as-errors
mix test
```

Activate the pre-push hook once per clone: `git config core.hooksPath .githooks`. Pre-push runs format / credo strict / compile on every push and the full suite when `mix.exs` changes.

Release = `mix.exs` `@version` bump on master. GH Actions handles tag + GitHub release + Hex publish, signed with the shared mob first-party key. Do NOT bump without explicit permission.
