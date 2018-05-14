defmodule Bepaid.HttpClient do
  @moduledoc false

  use HTTPoison.Base
  alias HTTPoison.Response

  @base_url "https://gateway.bepaid.by/transactions/"

  @doc false
  def parse_response({:ok, %Response{body: %{"transaction" =>
    %{"status" => "failed", "three_d_secure_verification" => %{"status" => "failed"}}}}}),
    do: {:error, "3-D Secure verification failed"}
  def parse_response({:ok, %Response{body: %{"transaction" => %{"status" => "failed", "message" => err}}}}),
    do: {:error, err}
  def parse_response({:ok, %Response{body: body, status_code: status}}) when status <300, do: {:ok, body}
  def parse_response({:ok, %Response{body: body}}), do: {:error, body}
  def parse_response(resp), do: resp

  @doc false
  def request(method, url, body \\ "", headers \\ [], options \\ []) do
    options = Keyword.merge([timeout: 50_000, recv_timeout: 50_000], options)
    headers = Enum.into(headers_for(method), headers)
    super(method, url, body, headers, options)
  end

  defp headers_for(:post), do: Enum.into(headers_for(:get), [{"Content-Type", "application/json"}])
  defp headers_for(:get), do: [auth_header(), {"Accept", "application/json"}]
  defp auth_header, do: {"Authorization", "Basic " <> Base.encode64("#{get_shop_id()}:#{get_key_secret()}")}

  defp get_shop_id, do: Application.get_env(:bepaid_ex, :shop_id) |> get_env_var()
  defp get_key_secret, do: Application.get_env(:bepaid_ex, :key_secret) |> get_env_var()

  defp get_env_var({:system, env_var}), do: System.get_env(env_var)
  defp get_env_var(binary) when is_binary(binary), do: binary
  defp get_env_var(integer) when is_integer(integer), do: integer

  defp process_url(url) do
    if url =~ ~r/^https?:/,
      do: url,
      else: @base_url <> url
  end

  defp process_response_body(body) do
    case Poison.decode(body) do
      {:ok, body} -> body
      error -> error
    end
  end
end
