use Mix.Config

config :bepaid_ex,
  shop_id: "1",
  key_secret: "BEPAID_KEY_SECRET",
  key_public: "BEPAID_KEY_PUBLIC"

config :exvcr,
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes",
  custom_cassette_library_dir: "test/fixture/custom_cassettes"
