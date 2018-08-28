defmodule DemoServerQLApi do
  use CommonGraphQLClient.Context,
    otp_app: :demo_client
end
