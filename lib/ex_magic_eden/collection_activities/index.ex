defmodule ExMagicEden.CollectionActivities.Index do
  alias ExMagicEden.Http

  @type symbol :: String.t()
  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type collection :: ExMagicEden.CollectionActivity.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [collection]} | {:error, error_reason}

  @spec get(symbol) :: result
  @spec get(symbol, params) :: result
  def get(symbol, params \\ %{}) do
    "/v2/collections/#{symbol}/activities"
    |> Http.Request.for_path()
    |> Http.Request.with_query(params)
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    data
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.CollectionActivity, transformations: [:snake_case]))
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
