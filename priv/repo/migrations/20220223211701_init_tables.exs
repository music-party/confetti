defmodule Confetti.Repo.Migrations.InitTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table("users", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name :string, null: false
      add :email, :citext, null: false
      add :confirmed?, :boolean, null: false
      add :admin?, :boolean, null: false, default: false
      add :settings, :map, null: false
      add :last_login, :utc_datetime_usec
      timestamps(type: :utc_datetime_usec)
    end

    create table("identities", primary_key: false) do
      add :country, :string, null: false
      add :display_name, :string, null: false
      add :email, :citext, null: false
      add :explicit_content, :map, null: false
      add :id, :string, primary_key: true
      add :images, :map, null: false
      add :product, :string, null: false
      add :user_id, references("users", on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false
      timestamps(type: :utc_datetime_usec)
    end

    create table("parties", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string, default: ""
      add :privacy, :string, default: "private"
      add :queue, {:array, :map}, null: false, default: []
      add :host_id, references("users", on_delete: :nilify_all, on_update: :update_all, type: :binary_id)
      timestamps(type: :utc_datetime_usec)
    end

    create table("tags", primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :weight, :float
      add :party_id, references("parties", on_delete: :delete_all, on_update: :update_all, type: :binary_id)
    end

    alter table("users") do
      add :current_party_id, references("parties", on_delete: :nilify_all, type: :binary_id)
    end

    create unique_index("users", [:email])
    create unique_index("identities", [:email])
    create index("users", [:current_party_id])
    create index("parties", [:host_id])
  end
end
