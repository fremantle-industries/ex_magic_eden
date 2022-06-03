defmodule ExMagicEden.CollectionStat do
  @type t :: %__MODULE__{}

  defstruct ~w[
    symbol
    floor_price
    listed_count
    volume_all
  ]a
end
