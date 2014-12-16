defmodule Exeque.Mixfile do
  use Mix.Project

  def project do
    [app: :exeque,
     version: "0.1.0",
     elixir: "~> 1.0.2",
     description: description,
     package:     package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: []]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    Exeque allows you to queue up a list of functions and specify how many workers should be used to run those functions.
    """
  end

  defp package do
    [
      contributors: [ "Duff OMelia <duff@omelia.org>"],
      licenses:     ["MIT"],
      links:        [github: "https://github.com/duff/exeque"]
    ]
  end

end
