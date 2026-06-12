%{
  name: :mob_themes,
  mob_version: "~> 0.6",
  style_spec_version: 1,
  description:
    "Mob's default theme collection — Obsidian (default), ObsidianGlass, Citrus, " <>
      "Birch, Material3 (all token-only)",
  # The boot default; the other four are one Mob.Theme.set/1 away
  # (see MobThemes.all/0). A richer multi-theme manifest shape (named
  # variants selectable via :default_style) can come later without breaking
  # this four-field minimum.
  theme: MobThemes.Obsidian
}
