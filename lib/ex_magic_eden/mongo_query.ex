defmodule ExMagicEden.MongoQuery do
  @type t :: %__MODULE__{}
  @type opt :: {:match, map} | {:sort, map} | {:skip, non_neg_integer} | {:limit, pos_integer}

  defstruct ~w[
    match
    skip
    limit
    sort
  ]a

  @spec new([opt]) :: t
  def new(opts) do
    match = Keyword.get(opts, :match) || %{}
    skip = Keyword.get(opts, :skip) || 0
    limit = Keyword.get(opts, :limit) || 20
    sort = Keyword.get(opts, :sort)

    %__MODULE__{
      match: match,
      skip: skip,
      limit: limit,
      sort: sort
    }
  end

  @spec to_string(t) :: String.t()
  def to_string(mongo_query) do
    json = %{
      "$match": mongo_query.match,
      "$skip": mongo_query.skip,
      "$limit": mongo_query.limit
    }

    mongo_query.sort
    |> case do
      nil -> json
      sort -> Map.put(json, "$sort", sort)
    end
    |> Jason.encode!()
  end
end
