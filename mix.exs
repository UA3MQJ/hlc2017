defmodule MiniApp.Mixfile do
  use Mix.Project

  def project do
    [app: :mini_app,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :poison, :plug, :cowboy],
     mod: {MiniApp, []}]
  end

  defp deps do
    [
     {:plug, "~>1.0"},
     {:cowboy, "~>1.0"},
     {:poison, "~> 2.0"},
     # {:benchwarmer, "~> 0.0.2"},
     # {:flow, "~> 0.11"},
     {:distillery, "~> 1.0"}
    ]
  end
end
