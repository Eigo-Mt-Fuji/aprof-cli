defmodule AprofCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :aprof_cli,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      build_embedded: true,
      releases: [
        aprof: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
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
      {:csv, "~> 2.2.0"},
      {:poison, "~> 3.1"},

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
  defp escript do
    [main_module: AprofCli, embed_elixir: true]
  end
end
