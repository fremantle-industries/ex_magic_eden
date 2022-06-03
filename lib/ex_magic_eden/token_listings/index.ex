defmodule ExMagicEden.TokenListings.Index do
  @type token_mint :: String.t()
  @type params :: %{
    optional(:offset) => non_neg_integer,
    optional(:limit) => non_neg_integer
  }
  @type token :: ExMagicEden.TokenListing.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [token]} | {:error, error_reason}

  @spec get(token_mint) :: result
  def get(token_mint) do
    "/v2/tokens/#{token_mint}/listings"
    |> ExMagicEden.HTTPClient.non_auth_get(%{})
    |> parse_response()
  end

  defp parse_response({:ok, tokens}) do
    tokens
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.TokenListing, transformations: [:snake_case]))
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
