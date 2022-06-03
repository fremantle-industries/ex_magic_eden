defmodule ExMagicEden.Collections.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExMagicEden.Collections.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "collections/index/get_ok" do
      assert {:ok, collections} = ExMagicEden.Collections.Index.get()
      assert length(collections) != 0
      assert %ExMagicEden.Collection{} = collection = Enum.at(collections, 0)
      assert collection.name != nil
      assert collection.is_flagged != nil
    end
  end

  test ".get/1 can limit the returned results" do
    use_cassette "collections/index/get_filter_limit_ok", match_requests_on: [:query] do
      assert {:ok, limit_500_collections} = ExMagicEden.Collections.Index.get(%{limit: 50})
      assert length(limit_500_collections) == 50

      assert {:ok, limit_100_collections} = ExMagicEden.Collections.Index.get(%{limit: 10})
      assert length(limit_100_collections) == 10
    end
  end

  test ".get/1 can filter with an offset" do
    use_cassette "collections/index/get_filter_offset_ok", match_requests_on: [:query] do
      assert {:ok, offset_0_collections} = ExMagicEden.Collections.Index.get(%{offset: 0, limit: 2})
      assert length(offset_0_collections) == 2
      assert offset_0_collection_1 = Enum.at(offset_0_collections, 1)
      assert offset_0_collection_1.name != nil

      assert {:ok, offset_1_collections} = ExMagicEden.Collections.Index.get(%{offset: 1, limit: 2})
      assert length(offset_1_collections) == 2
      assert offset_1_collection_0 = Enum.at(offset_1_collections, 0)
      assert offset_1_collection_0.name != nil

      assert offset_0_collection_1.name == offset_1_collection_0.name
    end
  end

  test ".get/n bubbles error tuples" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.Collections.Index.get() == {:error, :timeout}
    end
  end
end
