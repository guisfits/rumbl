defmodule Rumbl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  ##
  # Fields

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  ##
  # Changesets

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 3, max: 20)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_hash_pass()
  end

  ##
  # Privates

  defp put_hash_pass(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset),
    do: put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

  defp put_hash_pass(changeset), do: changeset
end
