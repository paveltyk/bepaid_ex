defmodule Bepaid.Gateway do
  @moduledoc """
  bePaid API client: https://docs.bepaid.by/ru/introduction
  """

  use HTTPoison.Base
  alias Bepaid.Payment
  alias HTTPoison.Response

  @shop_id Application.get_env(:bepaid_ex, :shop_id)
  @key_secret Application.get_env(:bepaid_ex, :key_secret)
  @base_url "https://gateway.bepaid.by/transactions/"

  def put_authorization(%Payment{} = payment), do: Map.from_struct(payment) |> post_request("authorizations")
  def put_charge(%Payment{} = payment), do: Map.from_struct(payment) |> post_request("payments")
  def void_authorization(uid, amount), do: %{parent_uid: uid, amount: amount} |> post_request("voids")
  def get_transaction(uid), do: exec(:get, uid, nil)
  def put_refund(uid, amount, reason \\ "Возврат средств"),
    do: %{parent_uid: uid, amount: amount, reason: reason} |> post_request("refunds")
  def put_refund(%{} = data), do: post_request(data, "refunds")

  @doc """
  Wrapper for exec(:post, url, params). More handy for piping
  """
  def post_request(data, url), do: exec(:post, url, %{request: data})

  @doc """
  Executes API request.
  Returns {:ok, data} or {:error, error, data}
  """
  def exec(:post, url, params), do: post(url, Poison.encode!(params)) |> parse_response
  def exec(:get, url, nil), do: get(url) |> parse_response
  def exec(:get, url, params) when is_map(params), do: get(url, [], params: params) |> parse_response
  def exec(url, params), do: exec(:post, url, params) |> parse_response


  # Seems bePaid updated their API, and this case no longer valid
  # defp parse_response({:ok, %Response{body: %{"transaction" => %{"status" => "failed", "authorization" => %{"status" => "incomplete"}}} = body}}),
  #   do: {:incomplete, body}
  defp parse_response({:ok, %Response{body: %{"transaction" =>
    %{"status" => "failed", "three_d_secure_verification" => %{"status" => "failed"}}}}}),
    do: {:error, "3-D Secure verification failed"}
  defp parse_response({:ok, %Response{body: %{"transaction" => %{"status" => "failed", "message" => err}}}}),
    do: {:error, err}
  defp parse_response({:ok, %Response{body: body, status_code: status}}) when status <300, do: {:ok, body}
  defp parse_response({:ok, %Response{body: body}}), do: {:error, body}
  defp parse_response(resp), do: resp

  defp headers_for(:post), do: Enum.into(headers_for(:get), [{"Content-Type", "application/json"}])
  defp headers_for(:get), do: [auth_header(), {"Accept", "application/json"}]
  defp auth_header, do: {"Authorization", "Basic " <> Base.encode64("#{get_env_var(@shop_id)}:#{get_env_var(@key_secret)}")}

  defp get_env_var(binary) when is_binary(binary), do: binary
  defp get_env_var(integer) when is_integer(integer), do: integer

  # HTTPoison function extends
  def request(method, url, body \\ "", headers \\ [], options \\ []) do
    options = Keyword.merge([timeout: 50_000, recv_timeout: 50_000], options)
    headers = Enum.into(headers_for(method), headers)
    super(method, url, body, headers, options)
  end

  defp process_url(url) do
    cond do
      url =~ ~r/^https?:/ -> url
      true -> @base_url <> url
    end
  end

  defp process_response_body(body) do
    case Poison.decode(body) do
      {:ok, body} -> body
      error ->
        IO.inspect "Failed to parse bePaid response: #{body}"
        error
    end
  end
end
