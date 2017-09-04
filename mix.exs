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
    [applications: [:logger, :plug, :cowboy],
     mod: {MiniApp, []}]
  end

  defp deps do
    [
     {:plug, "~>1.0"},
     {:cowboy, "~>1.0"}
    ]
  end
end
