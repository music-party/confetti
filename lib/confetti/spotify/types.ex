defmodule Confetti.Spotify.Types do
  @type album :: %{
          album_type: :album | :single | :compilation,
          artists: [artist()],
          available_markets: [String.t()],
          external_urls: external_urls(),
          href: String.t(),
          id: String.t(),
          images: [image()],
          name: String.t(),
          release_date: String.t(),
          release_date_precision: :year | :month | :day,
          restrictions: restriction(),
          total_tracks: integer(),
          tracks: any(),
          type: :album,
          uri: String.t()
        }

  @type artist :: %{}

  @typep external_urls :: %{spotify: String.t()}

  @typep image :: %{height: integer(), url: String.t(), width: integer()}

  @type private_user :: %{
          country: String.t(),
          display_name: String.t(),
          email: String.t(),
          explicit_content: %{
            filter_enabled: boolean(),
            filter_locked: boolean()
          },
          external_urls: external_urls(),
          followers: %{
            href: String.t(),
            total: integer()
          },
          href: String.t(),
          id: String.t(),
          images: [image()],
          product: String.t(),
          type: String.t(),
          uri: String.t()
        }

  @type restriction :: %{reason: :market | :product | :explicit}
end
