defmodule Tui.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_tui,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {MyTui.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3.0"},
      {:jason, "~> 1.4"},
      {:ex_ncurses, github: "jfreeze/ex_ncurses"}
    ]
  end
end

