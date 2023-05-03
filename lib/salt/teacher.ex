defmodule Salt.Teacher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teachers" do
    field(:user, :integer)
    field(:class, :integer)
    has_many(:classes, Salt.Class)
    timestamps()
  end

  @fields [:id, :user]

  # if no data - return a blank changeset
  def changeset(teacher, params \\ %{}) do
    teacher
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)

    # |> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
  end
end
