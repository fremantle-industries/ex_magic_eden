defmodule ExMagicEden.LaunchpadCollections.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExMagicEden.LaunchpadCollections.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get/1" do
    use_cassette "launchpad_collections/index/get_ok" do
      assert {:ok, launchpad_collections} = ExMagicEden.LaunchpadCollections.Index.get()
      assert length(launchpad_collections) != 0
      assert %ExMagicEden.LaunchpadCollection{} = launchpad_collection = Enum.at(launchpad_collections, 0)
      assert launchpad_collection.launch_datetime != nil
    end
  end

  test ".get/1 can limit the returned results" do
    use_cassette "launchpad_collections/index/get_filter_limit_ok", match_requests_on: [:query] do
      assert {:ok, limit_2_launchpad_collections} = ExMagicEden.LaunchpadCollections.Index.get(%{limit: 2})
      assert length(limit_2_launchpad_collections) == 2

      assert {:ok, limit_1_launchpad_collections} = ExMagicEden.LaunchpadCollections.Index.get(%{limit: 1})
      assert length(limit_1_launchpad_collections) == 1
    end
  end

  test ".get/1 can filter with an offset" do
    use_cassette "launchpad_collections/index/get_filter_offset_ok", match_requests_on: [:query] do
      assert {:ok, offset_0_launchpad_collections} = ExMagicEden.LaunchpadCollections.Index.get(%{offset: 0, limit: 2})
      assert length(offset_0_launchpad_collections) == 2
      assert offset_0_launchpad_collection_1 = Enum.at(offset_0_launchpad_collections, 1)
      assert offset_0_launchpad_collection_1.launch_datetime != nil

      assert {:ok, offset_1_launchpad_collections} = ExMagicEden.LaunchpadCollections.Index.get(%{offset: 1, limit: 2})
      assert length(offset_1_launchpad_collections) == 2
      assert offset_1_launchpad_collection_0 = Enum.at(offset_1_launchpad_collections, 0)
      assert offset_1_launchpad_collection_0.launch_datetime != nil

      assert offset_0_launchpad_collection_1.launch_datetime == offset_1_launchpad_collection_0.launch_datetime
    end
  end

  test ".get/n bubbles error tuples" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExMagicEden.LaunchpadCollections.Index.get() == {:error, :timeout}
    end
  end
end
