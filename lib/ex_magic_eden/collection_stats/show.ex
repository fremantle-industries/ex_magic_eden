defmodule ExMagicEden.CollectionStats.Show do
  alias ExMagicEden.Http

  @type symbol :: String.t()
  @type collection_stat :: ExMagicEden.CollectionStat.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, collection_stat} | {:error, error_reason}

  @spec get(symbol) :: result
  def get(symbol) do
    "/v2/collections/#{symbol}/stats"
    |> Http.Request.for_path()
    |> Http.Client.get()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    Mapail.map_to_struct(data, ExMagicEden.CollectionStat, transformations: [:snake_case])
  end

  defp parse_response({:error, _reason} = error) do
    error
  end
end
