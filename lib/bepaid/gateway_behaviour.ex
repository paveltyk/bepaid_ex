defmodule Bepaid.GatewayBehaviour do
  @moduledoc """
  Interface for Gateway. Could be used for defining your own module for testing
  """

  alias Bepaid.Payment

  @type http_response :: {:ok, map} | {:error, any}

  @callback put_authorization(Payment.t) :: http_response
  @callback void_authorization(uid :: any, amount :: any) :: http_response
  @callback get_transaction(String.t) :: http_response
  @callback put_refund(map) :: http_response
  @callback put_refund(uid :: any, amount :: any, reason :: String.t) :: http_response
  @callback post_request(data :: any, url :: any) :: http_response
  @callback put_charge(Payment.t) :: http_response
  @callback exec(atom, url :: any, params :: any) :: http_response
  @callback exec(url :: any, params :: any) :: http_response
end
