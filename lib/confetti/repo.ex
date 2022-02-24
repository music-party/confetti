defmodule Confetti.Repo do
  use Ecto.Repo,
    otp_app: :confetti,
    adapter: Ecto.Adapters.Postgres
end
