defmodule Conion.MixProject do
  use Mix.Project

  def project do
    [
      app: :cs,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: &docs/0
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :observer, :wx],
      mod: {Conion.Application, []}
    ]
  end

  def docs do
    [
      name: "Conion",
      description: ~s"""
        Conion is a simple, yet powerful, application to manage  
        your Elixir application in centralized way.
      """,
      main: "readme",
      extras: ["README.md"],
      source_url: "https://github.com/iboard/cea"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:elixir_uuid, "~> 1.2"}
    ]
  end
end
