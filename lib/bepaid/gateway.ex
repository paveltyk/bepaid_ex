defmodule Bepaid.Gateway do
  @moduledoc """
  Utility module for the [bePaid API](https://docs.bepaid.by/ru/introduction)

  Provides API wrapper functions for remote API.

  ## Examples:

      iex> {"uid" => uid} = Gateway.put_authorization(%Payment{amount: 10})
      %{...}
      iex> Gateway.void_authorization(uid, 10)
      %{...}
      iex> {"uid" => uid} = Gateway.put_charge(%Payment{amount: 10})
      %{...}

  """
  @behaviour Bepaid.GatewayBehaviour

  alias Bepaid.{HttpClient, Payment}

  @doc """
  Put authorization: https://docs.bepaid.by/ru/beyag/transactions/authorization

  Accepts `Payment` struct with credit card and customer info.
  """
  def put_authorization(%Payment{} = payment), do: Map.from_struct(payment) |> post_request("authorizations")

  @doc """
  Void authorization: https://docs.bepaid.by/ru/gateway/transactions/void

  Accepts UID of authorization transaction and amount in cents.
  """
  def void_authorization(uid, amount), do: %{parent_uid: uid, amount: amount} |> post_request("voids")

  @doc """
  Put charge: https://docs.bepaid.by/ru/gateway/transactions/payment

  Accepts `Payment` struct with credit card and customer info.
  """
  def put_charge(%Payment{} = payment), do: Map.from_struct(payment) |> post_request("payments")

  @doc """
  Load transaction: https://docs.bepaid.by/ru/gateway/transactions/query

  Accepts UID of payment or authorization transaction.
  """
  def get_transaction(uid), do: exec(:get, uid, nil)

  @doc """
  Put refund: https://docs.bepaid.by/ru/gateway/transactions/refund

  Accepts UID of transaction, amount in cents and reason (optionally).
  """
  def put_refund(uid, amount, reason \\ "Возврат средств") do
    %{parent_uid: uid, amount: amount, reason: reason}
    |> post_request("refunds")
  end
  def put_refund(%{} = data), do: post_request(data, "refunds")

  @doc """
  Wrapper for exec(:post, url, params). Handy for piping.
  """
  def post_request(data, url), do: exec(:post, url, %{request: data})

  @doc """
  Executes API request to bePaid API server. Accepts `:get` or `:post` atom as a first argument.

  Returns `{:ok, data}` or `{:error, error, data}`.
  """
  def exec(:post, url, params), do: HttpClient.post(url, Poison.encode!(params)) |> HttpClient.parse_response()
  def exec(:get, url, nil), do: HttpClient.get(url) |> HttpClient.parse_response()
  def exec(:get, url, params) when is_map(params), do: HttpClient.get(url, [], params: params) |> HttpClient.parse_response()
  def exec(url, params), do: exec(:post, url, params) |> HttpClient.parse_response()
end
