defmodule MobThemeCitrus.MixProject do
  use Mix.Project

  @source_url "https://github.com/GenericJam/mob_theme_citrus"

  def project do
    [
      app: :mob_theme_citrus,
      version: "0.1.0",
      elixir: "~> 1.17",
      deps: deps(),
      description: "Citrus theme for Mob — token-only style package (warm charcoal, lime accent)",
      package: package(),
      source_url: @source_url
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    # Local :mob path dep while the plugin system is dogfooded; switch to the
    # Hex constraint ("~> 0.6") when mob publishes. :mob_dev is test-only (the
    # manifest test runs the real style validator) and never ships.
    [
      {:mob, path: "../mob"},
      {:mob_dev, path: "../mob_dev", only: [:dev, :test], runtime: false},
      # Code quality — Credo + ex_slop (AI-pattern checks) + jump_credo_checks,
      # mirroring mob core's pre-commit gate.
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.2", only: [:dev, :test], runtime: false},
      {:jump_credo_checks, "~> 0.1.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      files: ~w(lib priv mix.exs README*)
    ]
  end
end
