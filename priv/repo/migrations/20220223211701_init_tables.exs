defmodule Confetti.Repo.Migrations.InitTables do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :spotify_id, :string, null: false
      add :spotify_access_token, :string, null: false
      add :spotify_refresh_token, :string, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:users, [:spotify_id])

    create table(:parties, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string, default: ""
      add :privacy, :string, default: "private"
      add :queue, :map

      timestamps(type: :utc_datetime_usec)
      add :deleted_at, :utc_datetime_usec, default: nil
    end

    alter table(:users) do
      add :current_party_id, references(:parties, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:users, [:current_party_id])

    alter table(:parties) do
      add :host_id, references(:users, on_delete: :nilify_all, type: :binary_id)
    end

    create index(:parties, [:host_id])

    create table(:tags, primary_key: false) do
      # add :id, :binary_id, primary_key: true
      add :party_id, references(:parties, type: :binary_id), primary_key: true
      add :name, :string, primary_key: true
      add :weight, :float

      timestamps(type: :utc_datetime_usec)
    end

    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      add :expires_in, :integer, null: false, default: 3600
      timestamps(type: :utc_datetime_usec, inserted_at: :created_at, updated_at: false)
    end
  end
end
