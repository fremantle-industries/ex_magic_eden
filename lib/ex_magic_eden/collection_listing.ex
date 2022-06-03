defmodule ExMagicEden.CollectionListing do
  @type t :: %__MODULE__{}

  defstruct ~w[
    pda_address
    auction_house
    token_address
    token_mint
    seller
    token_size
    price
  ]a
end
