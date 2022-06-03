defmodule ExMagicEden.TokenOffersReceived.Index do
  alias ExMagicEden.Http

  @type token_mint :: String.t()
  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type token_offer :: ExMagicEden.TokenOffer.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [token_offer]} | {:error, error_reason}

  @spec get(token_mint) :: result
  @spec get(token_mint, params) :: result
  def get(token_mint, params \\ %{}) do
    "/v2/tokens/#{token_mint}/offers_received"
    |> Http.Request.for_path()
    |> Http.Request.with_query(params)
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    data
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.TokenOffer, transformations: [:snake_case]))
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
