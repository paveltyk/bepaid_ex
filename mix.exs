defmodule Bepaid.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bepaid,
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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
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
