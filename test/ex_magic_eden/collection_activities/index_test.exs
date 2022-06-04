defmodule ExMagicEden.CollectionActivities.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExMagicEden.CollectionActivities.Index

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
    use_cassette "collection_activities/index/get_ok" do
      assert {:ok, collection_activities} = ExMagicEden.CollectionActivities.Index.get("bday")
      assert length(collection_activities) != 0
      assert %ExMagicEden.CollectionActivity{} = collection_listing = Enum.at(collection_activities, 0)
      assert collection_listing.token_mint != nil
    end
  end

  test ".get/1 can limit the returned results" do
    use_cassette "collection_activities/index/get_filter_limit_ok", match_requests_on: [:query] do
      assert {:ok, limit_2_collections} = ExMagicEden.CollectionActivities.Index.get("bday", %{limit: 2})
      assert length(limit_2_collections) == 2

      assert {:ok, limit_1_collections} = ExMagicEden.CollectionActivities.Index.get("bday", %{limit: 1})
      assert length(limit_1_collections) == 1
    end
  end

  test ".get/1 can filter with an offset" do
    use_cassette "collection_activities/index/get_filter_offset_ok", match_requests_on: [:query] do
      assert {:ok, offset_0_collections} = ExMagicEden.CollectionActivities.Index.get("bday", %{offset: 0, limit: 2})
      assert length(offset_0_collections) == 2
      assert offset_0_collection_1 = Enum.at(offset_0_collections, 1)
      assert offset_0_collection_1.token_mint != nil

      assert {:ok, offset_1_collections} = ExMagicEden.CollectionActivities.Index.get("bday", %{offset: 1, limit: 2})
      assert length(offset_1_collections) == 2
      assert offset_1_collection_0 = Enum.at(offset_1_collections, 0)
      assert offset_1_collection_0.token_mint != nil

      assert offset_0_collection_1.token_mint == offset_1_collection_0.token_mint
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      assert ExMagicEden.CollectionActivities.Index.get("bday") == {:error, :from_adapter}
    end
  end
end
