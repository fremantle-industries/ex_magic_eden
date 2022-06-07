defmodule ExMagicEden.Rpc.GetListedNFTsByQueryLite do
  @moduledoc """
  This is an undocumented RPC API endpoint that takes a mongodb query and returns a list of
  json results. The query parameter is required.

  https://www.mongodb.com/docs/manual/reference/operator/query/
  """

  alias ExMagicEden.Http
  alias ExMagicEden.MongoQuery

  @type mongo_query :: ExMagicEden.MongoQuery.t() | String.t()
  @type listed_nft :: ExMagicEden.ListedNFT.t()
  @type error_reason :: :parse_result_item | String.t()
  @type result :: {:ok, [listed_nft]} | {:error, error_reason}

  @spec call(mongo_query) :: result
  def call(mongo_query) do
    case mongo_query do
      %MongoQuery{} ->
        mongo_query
        |> MongoQuery.to_string()
        |> call()

      _ ->
        "/rpc/getListedNFTsByQueryLite"
        |> Http.Request.for_path()
        |> Http.Request.with_query(%{q: mongo_query})
        |> Http.Client.call_rpc()
        |> parse_response()
    end
  end

  defp parse_response({:ok, %{"results" => results}}) do
    results
    |> Enum.map(&Mapail.map_to_struct(&1, ExMagicEden.ListedNFT, transformations: [:snake_case]))
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
