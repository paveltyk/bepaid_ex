# BepaidEx - Elixir Library for bePaid payment processing gateway

[![CircleCI](https://circleci.com/gh/PavelTyk/bepaid_ex/tree/master.svg?style=shield)](https://circleci.com/gh/PavelTyk/bepaid_ex/tree/master)
[![Hex.pm](https://img.shields.io/librariesio/release/hex/bepaid_ex/0.9.0.svg)](https://hex.pm/packages/bepaid_ex)
[![Hex.pm](https://img.shields.io/hexpm/v/bepaid_ex.svg)](https://hex.pm/packages/bepaid_ex)

The BepaidEx Elixir library provides convenient access to the [bePaid API](https://docs.bepaid.by/en/introduction) from applications written in the Elixir language.

## Installation

Add `bepaid_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bepaid_ex, "~> 0.9.0"}
  ]
end
```

Update your dependencies:

```
$ mix deps.get
```

## Configuration

BepaidEx requires certain properties to be configured.

In order to load ENV vars at runtime, use `{:system, ENV_VAR_NAME}` notation.
Please note ENV vars have to be set prior app loading: `export BEPAID_SHOP_ID=123`...

```elixir
config :bepaid_ex,
  shop_id: {:system, "BEPAID_SHOP_ID"},
  key_secret: {:system, "BEPAID_KEY_SECRET"}
```

Otherwise you can set constant values via binaries:

```elixir
config :bepaid_ex,
  shop_id: "BEPAID_SHOP_ID_HERE",
  key_secret: "BEPAID_KEY_SECRET_HERE"
```

## Usage example:

```elixir
alias Bepaid.{Gateway, Payment}

%Payment{amount: 100, description: "Test payment", test: true}
|> Payment.set_tracking_id()
|> Payment.update_customer(%{ip: "127.0.0.1"})
|> Payment.update_credit_card(%{token: "TOKEN"})
|> Bepaid.put_charge()
```

## Links

* [Documentation][1]
* [Hex][2]

## License

Parameterize is released under [MIT][3] license.

[1]: https://hexdocs.pm/bepaid_ex/Bepaid.Gateway.html

[2]: https://hex.pm/packages/bepaid_ex

[3]: https://github.com/paveltyk/bepaid_ex/blob/master/LICENSE.md
