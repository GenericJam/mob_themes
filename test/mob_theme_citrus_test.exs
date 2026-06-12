defmodule MobThemeCitrusTest do
  use ExUnit.Case, async: true

  @style_dir Path.expand("..", __DIR__)

  describe "style manifest (tokens-only, MOB_STYLES.md minimum)" do
    test "loads and validates via the real mob_dev style validator" do
      assert {:ok, m} = MobDev.Style.load(@style_dir)
      assert {:ok, ^m} = MobDev.Style.validate(m)
      assert m.name == :mob_theme_citrus
      assert m.theme == MobThemeCitrus.Theme
      assert m.style_spec_version == 1
    end
  end

  describe "theme/0 (the only contract: a module exporting Mob.Theme.t())" do
    test "builds a complete theme struct with the citrus palette" do
      theme = MobThemeCitrus.Theme.theme()
      assert %Mob.Theme{} = theme
      # The identity tokens (parity with the old core Mob.Theme.Citrus).
      assert theme.primary == :lime_400
      assert theme.background == 0xFF111209
      assert theme.border == 0xFF323420
    end

    test "is settable through every Mob.Theme.set/1 form" do
      before = Mob.Theme.current()
      on_exit(fn -> Mob.Theme.set(before) end)

      assert :ok = Mob.Theme.set(MobThemeCitrus.Theme)
      assert Mob.Theme.current() == MobThemeCitrus.Theme.theme()

      assert :ok = Mob.Theme.set({MobThemeCitrus.Theme, primary: :lime_300})
    end
  end
end
