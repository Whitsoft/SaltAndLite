defmodule Salt.Classtitle do
  use Ecto.Schema
  # import Ecto.Changeset
  # alias Salt.{Class, Classtitle}
  schema "classtitles" do
    field(:description, :string)
    has_many(:classes, Salt.Class)
    timestamps()
  end

  def changeset(classtitle, params \\ %{}) do
    classtitle
    |> Ecto.Changeset.cast(params, [:description])
  end
end
