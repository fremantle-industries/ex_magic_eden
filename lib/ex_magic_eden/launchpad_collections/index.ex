defmodule ExMagicEden.LaunchpadCollections.Index do
  alias ExMagicEden.Http

  @type symbol :: String.t()
  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type launchpad_collection :: ExMagicEden.LaunchpadCollection.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [launchpad_collection]} | {:error, error_reason}

  @spec get() :: result
  @spec get(params) :: result
  def get(params \\ %{}) do
    "/v2/launchpad/collections"
    |> Http.Request.for_path()
    |> Http.Request.with_query(params)
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    data
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.LaunchpadCollection, transformations: [:snake_case]))
    |> Enum.reduce(
      {:ok, []},
      fn
        {:ok, i}, {:ok, acc} -> {:ok, acc ++ [i]}
        _, _acc -> {:error, :parse_result_item}
      end
    )
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
