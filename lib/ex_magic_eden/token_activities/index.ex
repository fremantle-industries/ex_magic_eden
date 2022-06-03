defmodule ExMagicEden.TokenActivities.Index do
  alias ExMagicEden.Http

  @type symbol :: String.t()
  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type token :: ExMagicEden.TokenActivity.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [token]} | {:error, error_reason}

  @spec get(symbol) :: result
  @spec get(symbol, params) :: result
  def get(symbol, params \\ %{}) do
    # "/v2/tokens/#{symbol}/activities"
    # |> ExMagicEden.HTTPClient.non_auth_get(params)
    # |> parse_response()

    "/v2/tokens/#{symbol}/activities"
    |> Http.Request.for_path()
    |> Http.Request.with_query(params)
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, tokens}) do
    tokens
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.TokenActivity, transformations: [:snake_case]))
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
