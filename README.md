# mob_themes

Mob's default theme collection — five token-only looks in one style package:
Obsidian (default), ObsidianGlass, Citrus, Birch, Material3.

```elixir
# mob.exs
config :mob, :styles, [:mob_themes]
config :mob, :default_style, :mob_themes   # boots into Obsidian

# switch any time
Mob.Theme.set(MobThemes.Citrus)
```

Core keeps light/dark/adaptive as the neutral baseline. Nothing here is
sacred — these are decent defaults to expand on.

## Development

Clone, then run once:

```bash
mix setup
```

That fetches deps and activates the repo's git hooks (`.githooks/pre-push`):
`mix format --check`, `mix credo --strict` (incl. ExSlop), and `mix compile --warnings-as-errors` run on every push, plus the full test
suite when `mix.exs` changes — the same gate CI enforces before publishing.
