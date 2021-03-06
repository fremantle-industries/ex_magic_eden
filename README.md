# ExMagicEden
[![Build Status](https://github.com/fremantle-industries/ex_magic_eden/workflows/test/badge.svg?branch=main)](https://github.com/fremantle-industries/ex_magic_eden/actions?query=workflow%3Atest)
[![hex.pm version](https://img.shields.io/hexpm/v/ex_magic_eden.svg?style=flat)](https://hex.pm/packages/ex_magic_eden)

Magic Eden API client for Elixir

## Installation

Add the `ex_magic_eden` package to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_magic_eden, "~> 0.0.6"}
  ]
end
```

## Requirements

- Erlang 22+
- Elixir 1.13+

## API Documentation

https://api.magiceden.dev

## REST API

#### Tokens

- [x] `GET /tokens/:token_mint`
- [x] `GET /tokens/:token_mint/listings`
- [x] `GET /tokens/:token_mint/offer_received`
- [x] `GET /tokens/:token_mint/activities`

#### Wallets

- [ ] `GET /wallets/:wallet_address/tokens`
- [ ] `GET /wallets/:wallet_address/activities`
- [ ] `GET /wallets/:wallet_address/offers_made`
- [ ] `GET /wallets/:wallet_address/offers_received`
- [ ] `GET /wallets/:wallet_address/escrow_balance`
- [ ] `GET /wallets/:wallet_address`

#### Collections

- [x] `GET /collections`
- [x] `GET /collections/:symbol/listings`
- [x] `GET /collections/:symbol/activities`
- [x] `GET /collections/:symbol/stats`

#### Launchpad

- [x] `GET /launchpad/collections`

#### Instructions

- [ ] `GET /instructions/buy`
- [ ] `GET /instructions/buy_now`
- [ ] `GET /instructions/buy_cancel`
- [ ] `GET /instructions/buy_change_price`
- [ ] `GET /instructions/sell`
- [ ] `GET /instructions/sell_now`
- [ ] `GET /instructions/sell_cancel`
- [ ] `GET /instructions/sell_change_price`
- [ ] `GET /instructions/deposit`
- [ ] `GET /instructions/withdraw`

## Undocumented RPC API

- [x] `GET /rpc/getListedNFTsByQueryLite`

## Authors

- Alex Kwiatkowski - alex+git@fremantle.io

## License

`ex_magic_eden` is released under the [MIT license](./LICENSE)
