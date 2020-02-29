defmodule ExAwsConf.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_awsconf,
      version: "0.1.1",
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      source_url: "https://github.com/Eigo-Mt-Fuji/ex-awsconf",
      homepage_url: "https://github.com/Eigo-Mt-Fuji/ex-awsconf",
      releases: [
        ex_awsconf: [
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
      {:jason, "~> 1.1.2"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
  defp escript do
    [main_module: ExAwsConf]
  end
  defp description() do
    "A simple Elixir cli tool for generating aws-cli config."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ex_awsconf",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Eigo-Mt-Fuji/ex-awsconf"}
    ]
  end
end
