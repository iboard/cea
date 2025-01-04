defmodule CentralScrutinizer.Store.BucketSupervisor do
  @moduledoc """
  A `DynamicSupervisor` whith `Bucket` children.
  """

  use DynamicSupervisor
  use Cea.Common.CentralLogger
  alias CentralScrutinizer.Store.Bucket

  @doc "Started from `CentralScrutinizer.Application`"
  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Returns a list of bucket-names of all Buckets alive.
  """
  def list_buckets() do
    try do
      DynamicSupervisor.which_children(__MODULE__)
      |> Enum.map(&get_bucket_name/1)
    rescue
      _ -> []
    end
  end

  @doc """
  Starts a new Bucket if not running yet.
  Returns {:ok, pid}
  """
  def start_child(args) do
    name = args[:initial_state][:bucket_name]
    opts = {Bucket, name: :"bucket_#{name}", bucket_name: name}

    DynamicSupervisor.start_child(__MODULE__, opts)
    |> respond_tuple()
  end

  # DynamicSupervisor Callbacks

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # private implementation

  defp respond_tuple(result) do
    case result do
      {:ok, pid} when is_pid(pid) ->
        {:ok, pid}

      {:error, {:already_started, pid}} when is_pid(pid) ->
        {:ok, pid}
    end
  end

  defp get_bucket_name({_, pid, :worker, [Bucket]}) do
    Bucket.bucket_name(pid)
  end

  defp get_bucket_name(unknown) do
    log(unknown, :error, "unsuported!")
    "unknown"
  end
end
