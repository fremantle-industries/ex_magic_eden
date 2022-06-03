defmodule ExMagicEden.TokenListings.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExMagicEden.TokenListings.Index

  @mint_address "5joGadC3Z5aSm4PsCFRtoAKTEtvLYT2iU8nFaNTcjyMe"

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "token_listings/index/get_ok" do
      assert {:ok, token_listings} = ExMagicEden.TokenListings.Index.get(@mint_address)
      assert length(token_listings) != 0
      assert %ExMagicEden.TokenListing{} = token_listing = Enum.at(token_listings, 0)
      assert token_listing.pda_address != nil
    end
  end

  test ".get/n bubbles error tuples" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.TokenListings.Index.get(@mint_address) == {:error, :timeout}
    end
  end
end
