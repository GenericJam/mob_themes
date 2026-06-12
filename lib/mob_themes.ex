defmodule MobThemes do
  @moduledoc """
  Mob's default theme collection — one style package, five looks
  (extracted from mob core in Wave 4; light/dark/adaptive remain core's
  neutral baseline):

    * `MobThemes.Obsidian` — deep violet dark (the package default)
    * `MobThemes.ObsidianGlass` — obsidian with translucent depth
    * `MobThemes.Citrus` — warm charcoal, lime accent
    * `MobThemes.Birch` — light, paper-warm
    * `MobThemes.Material3` — Material You baseline palette (tokens only;
      pixel-perfect M3 needs the native-override style tier, not yet built)

  ## As the app default (the styles lane)

      # mob.exs
      config :mob, :styles, [:mob_themes]
      config :mob, :default_style, :mob_themes

  Boot applies the package default (Obsidian). Switch at runtime to any of
  the five:

      Mob.Theme.set(MobThemes.Citrus)
      Mob.Theme.set({MobThemes.Birch, primary: :emerald_500})
  """

  @doc "All themes in the collection."
  @spec all() :: [module()]
  def all,
    do: [
      MobThemes.Obsidian,
      MobThemes.ObsidianGlass,
      MobThemes.Citrus,
      MobThemes.Birch,
      MobThemes.Material3
    ]
end
