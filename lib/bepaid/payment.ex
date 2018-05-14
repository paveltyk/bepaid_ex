defmodule Bepaid.Payment do
  @moduledoc """
  A structure to represent bePaid API request payload.

  Example structure:

      %{
        amount: 100,
        currency: "BYN",
        description: "Test transaction",
        tracking_id: "your_uniq_number",
        language: "en",
        credit_card: %{
          token: "40bd001563085fc35165329ea1ff5c5ecbdbbeef40bd001563085fc35165329e"
        },
        additional_data: %{
          receipt_text: ["First line", "Second Line"]
        },
        customer: %{
          ip: "127.0.0.1",
          email: "john@example.com"
        }
      }

  More info: https://docs.bepaid.by/ru/gateway/transactions/payment
  """

  alias Bepaid.Payment
  defstruct amount: nil,
            currency: "BYN",
            description: nil,
            tracking_id: nil,
            language: "ru",
            notification_url: nil,
            return_url: nil,
            credit_card: %{},
            additional_data: %{},
            customer: %{}

  @doc """
  Update credit card information in a Bepaid.Payment struct.
  """
  def update_credit_card(%Payment{credit_card: credit_card} = payment, %{} = attrs) do
    %{payment | credit_card: Map.merge(credit_card, attrs)}
  end

  @doc """
  Update customer information in a Bepaid.Payment struct.
  """
  def update_customer(%Payment{customer: customer} = payment, %{} = attrs) do
    %{payment | customer: Map.merge(customer, attrs)}
  end

  @doc """
  Update additional data information in a Bepaid.Payment struct.
  """
  def update_additional_data(%Payment{additional_data: additional_data} = payment, %{} = attrs) do
    %{payment | additional_data: Map.merge(additional_data, attrs)}
  end

  @doc """
  Set or generate tracking ID for the payment. Required by bePaid API.
  """
  def set_tracking_id(%Payment{} = payment), do: set_tracking_id(payment, generate_tracking_id())
  def set_tracking_id(%Payment{} = payment, tracking_id), do: %{payment | tracking_id: tracking_id}

  defp generate_tracking_id, do: Nanoid.generate(32, "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
end
