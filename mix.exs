defmodule ElixirCqrsEs.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_cqrs_es,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :rethink]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:uuid, "~> 1.0"},
      {:json,   "~> 0.3.0"},
      {:rethink, github: "EddyShure/rethink"}
    ]
  end
end
