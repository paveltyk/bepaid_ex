defmodule Bepaid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bepaid_ex,
      version: "0.9.0",
      elixir: "~> 1.5",
      deps: deps(),

      # Hex
      description: "Elixir library for bePaid API (payment processing gateway)",
      package: package(),

      # Docs
      name: "BepaidEx",
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {Bepaid, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18", only: :dev, runtime: false},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.10", only: :test},
      {:nanoid, "~> 1.0.1"}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
      maintainers: ["Pavel Tsiukhtsiayeu", "Mike Andrianov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/paveltyk/bepaid_ex"},
    ]
  end
end
