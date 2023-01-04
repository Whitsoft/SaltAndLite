defmodule Salt.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email_address, :string)
    field(:password, :string, virtual: true)
    field(:hashed_password, :string)
    field(:current, :string)
    field(:roles, {:array, :string})
    has_one(:profiles, Salt.Profile)
    has_many(:students, Salt.Student)
    timestamps()
  end

  def changeset(user, data \\ %{}) do
    user
    |> cast(data, [:username, :email_address])
    |> validate_required([:username, :email_address, :hashed_password])
    |> validate_format(:email_address, ~r/@/)
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
  end

  def changeset_with_password(user, data \\ %{}) do
    user
    |> cast(data, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(data)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, Salt.Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end
