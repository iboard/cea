defmodule Conion do
  @moduledoc """
  Documentation for `Conion`'s main API.
  """
  use Conion.Common.CentralLogger

  alias Conion.Common.{Configuration}

  # General Configuration

  @doc """
  All confiurations are loaded fro ENV vars. Where the default value for each key is 
  configured in the application's configuration.
  """
  def configurations,
    do: [
      # { {ENV,      :app,    :key, default}, set-function/1                }
      {{"LOG_LEVEL", :logger, :level, :info}, &Configuration.set_log_level/1}
    ]

  # API

  @doc """
  alive? returns true if the Conion.Server and all it's children are running.
  """
  def alive?(), do: all_up?()

  @doc """
  Return the list of children, that should be started with the `Conion.Application`.
  """
  def application_children(),
    do: Application.get_env(:conion, :application_children, [])

  @doc """
  Load the configuration from ENV and config.exs and call the 
  setup functions for each configuration key.
  Returns a map with {ENV, return_from_load_configuration_for/2}
  """
  def configure(),
    do:
      configurations()
      |> Enum.reduce(%{}, &Configuration.load_configuration_for/2)

  # Private implementations

  defp all_up?(), do: Conion.application_children() |> Enum.all?(&is_up?/1)

  defp is_up?({module, _opts}) do
    not is_nil(GenServer.whereis(module))
    |> tap(fn
      false -> log(module, :warning, "module is not alive.")
      true -> log(module, :debug, "module is alive.")
    end)
  end
end
