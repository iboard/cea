defmodule Conion.Store.Persistor.File do
  @moduledoc """
  Persists and reads data to raw files.
  """

  @behaviour Conion.Store.Persistor

  @doc """
  Write data to filename and returns :ok on success.
  Otherwise raises an exception from `File.write!/3`
  """
  def write!(filename, data) do
    bin = :erlang.term_to_binary(data)
    File.write!(filename, bin)
  end

  @doc """
  Read data from filename and returns data on success.
  Otherwise raises an exception from `File.read!/1`
  """
  def read!(filename) do
    case File.read(filename) do
      {:ok, bin} -> :erlang.binary_to_term(bin)
      _ -> %{}
    end
  end
end
