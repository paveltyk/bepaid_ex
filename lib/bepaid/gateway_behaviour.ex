defmodule Bepaid.GatewayBehaviour do
  @moduledoc """
  Interface for Gateway. Could be used for defining your own module for testing
  """

  alias Bepaid.Payment

  @type http_response :: {:ok, map} | {:error, any}

  @doc """
  """
  @callback put_authorization(Payment.t) :: http_response

  @doc """
  """
  @callback void_authorization(Payment.t) :: http_response

  @doc """
  """
  @callback get_transaction(String.t) :: http_response

  @doc """
  """
  @callback put_refund() :: http_response

  @doc """
  """
  @callback post_request(Payment.t) :: http_response

  @doc """
  """
  @callback put_charge(Payment.t) :: http_response

  @doc """
  """
  @callback exec(any) :: http_response
end
