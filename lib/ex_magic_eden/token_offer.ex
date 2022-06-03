defmodule ExMagicEden.TokenOffer do
  @type t :: %__MODULE__{}

  defstruct ~w[
    pda_address
    token_mint
    auction_house
    buyer
    buyer_referral
    token_size
    price
    expiry
  ]a
end
