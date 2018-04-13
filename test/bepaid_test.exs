defmodule BepaidTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Bepaid.{ Gateway, Payment }

  setup_all do
    HTTPoison.start
  end

  describe "Gateway.put_authorization" do
    test "success" do
      use_cassette "success" do
        {:ok, %{"transaction" => transaction}} =
          %Payment{}
          |> Payment.set_tracking_id
          |> Payment.update_credit_card(%{token: "11111111-1111-1111-1111-111111111111"})
          |> Map.merge(%{amount: 10, description: "Valid"})
          |> Gateway.put_authorization

        assert transaction["amount"] == 10
        assert transaction["message"] == "Successfully processed"
        assert transaction["status"] == "successful"
      end
    end

    test "failure - invalid credit card token" do
      use_cassette "failure" do
        {:error, %{"response" => response}} =
          %Payment{}
          |> Payment.set_tracking_id
          |> Payment.update_credit_card(%{token: "11111111-1111-1111-1111-111111111111"})
          |> Map.merge(%{amount: 10, description: "Valid"})
          |> Gateway.put_authorization

        assert response["message"] == "Token does not exist."
      end
    end
  end

  describe "Gateway.void_authorization" do
    test "success" do
      use_cassette "success" do
        {:ok, %{"transaction" => transaction}} = Gateway.void_authorization("3596682-d0c9c1f588", 10)

        assert transaction["message"] == "Successfully processed"
        assert transaction["status"] == "successful"
      end
    end

    test "failure - invalid uid" do
      use_cassette "failure" do
        {:error, %{"response" => response}} = Gateway.void_authorization("1111111-1111111111", 10)

        assert response["message"] == "Parent uid Parent transaction is not found."
      end
    end
  end

  describe "Gateway.put_charge" do
    test "success" do
      use_cassette "success" do
        {:ok, %{"transaction" => transaction}} =
          %Payment{}
          |> Payment.set_tracking_id
          |> Payment.update_credit_card(%{token: "11111111-1111-1111-1111-111111111111"})
          |> Map.merge(%{amount: 100, description: "Valid"})
          |> Gateway.put_charge

        assert transaction["amount"] == 100
        assert transaction["message"] == "Successfully processed"
        assert transaction["status"] == "successful"
      end
    end

    test "failure - invalid credit card token" do
      use_cassette "failure" do
        {:error, %{"response" => response}} =
          %Payment{}
          |> Payment.set_tracking_id
          |> Payment.update_credit_card(%{token: "11111111-1111-1111-1111-111111111111"})
          |> Map.merge(%{amount: 100, description: "Valid"})
          |> Gateway.put_charge

        assert response["message"] == "Token does not exist."
      end
    end
  end

  describe "Gateway.get_charge" do
    test "success" do
      use_cassette "success" do
        {:ok, %{"transaction" => transaction}} = Gateway.get_transaction("3596794-18f91f7c1e")

        assert transaction["amount"] == 100
        assert transaction["message"] == "Successfully processed"
        assert transaction["status"] == "successful"
      end
    end

    test "failure invalid uid" do
      use_cassette "failure" do
        {:error, %{"response" => response}} = Gateway.get_transaction("3596794-18f91f7c11")

        assert "Record not found" == response["message"]
      end
    end
  end
end
