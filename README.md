# Bepaid Elixir Library

The Bepaid Elixir library provides convenient access to the [bePaid API](https://docs.bepaid.by/en/introduction) from applications written in the Elixir language.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bepaid` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bepaid, "~> 0.9.0"}
  ]
end
```

## Configuration

Bepaid requires certain properties to be configured:

```elixir
config :bepaid_ex,
  shop_id: "BEPAID_SHOP_ID",
  key_secret: "BEPAID_KEY_SECRET",
  key_public: "BEPAID_KEY_PUBLIC"
```

Add :bepaid_ex to your applications list

```elixir
def application do
  [applications: [:bepaid_ex]]
end
```
