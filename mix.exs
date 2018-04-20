defmodule Bepaid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bepaid_ex,
      version: "0.9.0",
      description: description(),
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {Bepaid, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.10", only: :test},
      {:nanoid, "~> 1.0.1"}
    ]
  end

  defp description do
    """
    Elixir library for bePaid API. https://bepaid.by
    """
  end


  defp package do
    [
      name: "bePaid",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Pavel Tsiukhtsiayeu", "Mike Andrianov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/paveltyk/bepaid_ex"},
    ]
  end
end
