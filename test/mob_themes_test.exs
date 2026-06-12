defmodule MobThemesTest do
  use ExUnit.Case, async: true

  @style_dir Path.expand("..", __DIR__)

  test "style manifest validates via the real mob_dev validator (default: Obsidian)" do
    assert {:ok, m} = MobDev.Style.load(@style_dir)
    assert {:ok, ^m} = MobDev.Style.validate(m)
    assert m.name == :mob_themes
    assert m.theme == MobThemes.Obsidian
  end

  test "every theme in the collection builds a complete Mob.Theme struct" do
    for mod <- MobThemes.all() do
      assert %Mob.Theme{} = mod.theme(), "#{inspect(mod)} did not build"
    end
  end

  test "the collection keeps each look's identity token" do
    assert MobThemes.Citrus.theme().primary == :lime_400
    assert MobThemes.Citrus.theme().background == 0xFF111209
    refute MobThemes.Obsidian.theme().primary == MobThemes.Birch.theme().primary
  end

  test "every theme is settable through Mob.Theme.set/1" do
    before = Mob.Theme.current()
    on_exit(fn -> Mob.Theme.set(before) end)

    for mod <- MobThemes.all() do
      assert :ok = Mob.Theme.set(mod)
      assert Mob.Theme.current() == mod.theme()
    end
  end

  test "ObsidianGlass is Obsidian with glass: true (the identity it shipped with)" do
    glass = MobThemes.ObsidianGlass.theme()
    assert glass.glass == true
    assert %{glass.primary => true} == %{MobThemes.Obsidian.theme().primary => true}
  end
end
