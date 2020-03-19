defmodule Tide.MixProject do
  use Mix.Project

  def project do
    [
      app: :tide,
      description: "Communicate with Ruby via Erlport",
      version: "0.3.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/elct9620/tide.ex"
    ]
  end

  def package() do
    [
      maintainers: ["Aotokitsuruya"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/elct9620/tide.ex"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:erlport, "~> 0.10.1"},
      {:poolboy, "~> 1.5"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
