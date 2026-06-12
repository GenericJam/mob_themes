%{
  name: :mob_theme_citrus,
  mob_version: "~> 0.6",
  style_spec_version: 1,
  description: "Citrus — warm charcoal with a lime-green accent (token-only)",
  # Tokens only: the baseline native primitives render with this palette.
  # (The native-override tier — custom per-component views — is the mob_m3
  # case and a different style_spec surface.)
  theme: MobThemeCitrus.Theme
}
