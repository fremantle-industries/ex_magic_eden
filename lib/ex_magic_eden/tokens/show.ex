defmodule ExMagicEden.Tokens.Show do
  alias ExMagicEden.Http

  @type token_mint :: String.t()
  @type token :: ExMagicEden.Token.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, token} | {:error, error_reason}

  @spec get(token_mint) :: result
  def get(token_mint) do
    "/v2/tokens/#{token_mint}"
    |> Http.Request.for_path()
    |> Http.Client.send()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    Mapail.map_to_struct(data, ExMagicEden.Token, transformations: [:snake_case])
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
