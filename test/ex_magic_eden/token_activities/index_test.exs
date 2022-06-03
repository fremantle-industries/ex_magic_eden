defmodule ExMagicEden.TokenActivities.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExMagicEden.TokenActivities.Index

  # Trippin Ape
  # https://magiceden.io/item-details/5C5B6qnGERpdmVApUNShH4HvfmDmEKjWeNEmDWDSA6Y4?name=Trippin%27-Ape-Tribe-%239537
  @mint_address "5C5B6qnGERpdmVApUNShH4HvfmDmEKjWeNEmDWDSA6Y4"

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "token_activities/index/get_ok" do
      assert {:ok, token_activities} = ExMagicEden.TokenActivities.Index.get(@mint_address)
      assert length(token_activities) != 0
      assert %ExMagicEden.TokenActivity{} = token_listing = Enum.at(token_activities, 0)
      assert token_listing.token_mint != nil
    end
  end

  test ".get/1 can limit the returned results" do
    use_cassette "token_activities/index/get_filter_limit_ok", match_requests_on: [:query] do
      assert {:ok, limit_2_tokens} = ExMagicEden.TokenActivities.Index.get(@mint_address, %{limit: 2})
      assert length(limit_2_tokens) == 2

      assert {:ok, limit_1_tokens} = ExMagicEden.TokenActivities.Index.get(@mint_address, %{limit: 1})
      assert length(limit_1_tokens) == 1
    end
  end

  test ".get/1 can filter with an offset" do
    use_cassette "token_activities/index/get_filter_offset_ok", match_requests_on: [:query] do
      assert {:ok, offset_0_tokens} = ExMagicEden.TokenActivities.Index.get(@mint_address, %{offset: 0, limit: 2})
      assert length(offset_0_tokens) == 2
      assert offset_0_token_1 = Enum.at(offset_0_tokens, 1)
      assert offset_0_token_1.token_mint != nil

      assert {:ok, offset_1_tokens} = ExMagicEden.TokenActivities.Index.get(@mint_address, %{offset: 1, limit: 2})
      assert length(offset_1_tokens) == 2
      assert offset_1_token_0 = Enum.at(offset_1_tokens, 0)
      assert offset_1_token_0.token_mint != nil

      assert offset_0_token_1.token_mint == offset_1_token_0.token_mint
    end
  end

  test ".get/n bubbles error tuples" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.TokenActivities.Index.get(@mint_address) == {:error, :timeout}
    end
  end
end
