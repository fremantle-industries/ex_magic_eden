defmodule ExMagicEden.TokenListings.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExMagicEden.TokenListings.Index

  @mint_address "5joGadC3Z5aSm4PsCFRtoAKTEtvLYT2iU8nFaNTcjyMe"

  defmodule TestAdapter do
    def send(_request) do
      {:error, :from_adapter}
    end
  end

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
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      assert ExMagicEden.TokenListings.Index.get(@mint_address) == {:error, :from_adapter}
    end
  end
end
