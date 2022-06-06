defmodule ExMagicEden.Rpc.GetListedNFTsByQueryLiteTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use WithEnv
  doctest ExMagicEden.Rpc.GetListedNFTsByQueryLite

  @base_mongo_query ~s({"$match":{}})

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
    use_cassette "rpc/get_listed_nfts_by_query_lite/call_ok" do
      assert {:ok, listed_nfts} = ExMagicEden.Rpc.GetListedNFTsByQueryLite.call(@base_mongo_query)
      assert length(listed_nfts) > 0
      assert %ExMagicEden.ListedNFT{} = listed_nft = Enum.at(listed_nfts, 0)
      assert listed_nft.collection_name != nil
    end
  end

  test ".get/1 can take a mongo query" do
    use_cassette "rpc/get_listed_nfts_by_query_lite/call_with_mongo_query_ok" do
      mongo_query = ExMagicEden.MongoQuery.new([])

      assert {:ok, listed_nfts} = ExMagicEden.Rpc.GetListedNFTsByQueryLite.call(mongo_query)
      assert length(listed_nfts) > 0
      assert %ExMagicEden.ListedNFT{} = listed_nft = Enum.at(listed_nfts, 0)
      assert listed_nft.collection_name != nil
    end
  end

  test ".get/1 can filter by collection symbol" do
    use_cassette "rpc/get_listed_nfts_by_query_lite/call_filter_by_collection_symbol_ok" do
      mongo_query = ExMagicEden.MongoQuery.new(match: %{"collectionSymbol" => "okay_bears"})

      assert {:ok, listed_nfts} = ExMagicEden.Rpc.GetListedNFTsByQueryLite.call(mongo_query)
      assert length(listed_nfts) > 0
      assert Enum.all?(listed_nfts, & &1.collection_name == "okay_bears") == true
    end
  end

  test ".get/n bubbles error tuples" do
    with_env put: [ex_magic_eden: [adapter: TestAdapter]] do
      assert ExMagicEden.Rpc.GetListedNFTsByQueryLite.call(@base_mongo_query) == {:error, :from_adapter}
    end
  end
end
