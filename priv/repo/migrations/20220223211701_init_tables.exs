defmodule Confetti.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string
      add :spotify_access_token, :string
      add :spotify_refresh_token, :string

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:users, [:spotify_id])

    create table(:parties, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :privacy, :string
      add :host_id, references(:users, on_delete: :nilify_all, type: :binary_id)

      timestamps()
    end

    create index(:parties, [:host])

    modify table(:users) do
      add :current_party_id, references(:parties, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:users, [:current_party])

    create table(:tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :weight, :float
      add :party_id, references(:parties, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:tags, [:party])

    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
    end

    create index
  end
end
