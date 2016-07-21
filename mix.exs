defmodule HedwigHipChat.Mixfile do
  use Mix.Project

  @version "0.9.5"
  @source_url "https://github.com/jwarlander/hedwig_hipchat"

  def project do
    [app: :hedwig_hipchat,
     name: "Hedwig HipChat",
     source_url: @source_url,
     version: @version,
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     description: "A HipChat adapter for Hedwig",
     deps: deps,
     docs: [extras: ["README.md"], main: "readme"]]
  end

  def application do
    [applications: [:logger, :hedwig, :romeo]]
  end

  defp deps do
    [{:hedwig, "1.0.0-rc.4"},
     {:romeo, "~> 0.6"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
     maintainers: ["Johan Wärlander"],
     licenses: ["MIT"],
     links: %{
       "GitHub" => @source_url
     }]
  end
end
