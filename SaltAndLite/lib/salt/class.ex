defmodule Salt.Class do
  use Ecto.Schema
  import Ecto.Changeset
  alias Salt.{Registration, Classtitle}

  schema "classes" do
    field(:location, :string)
    field(:fallfee, :integer)
    field(:springfee, :integer)
    field(:semester, :integer)
    belongs_to(:period, Salt.Period)
    belongs_to(:section, Salt.Section)
    belongs_to(:teacher, Salt.User)
    belongs_to(:helper1, Salt.User)
    belongs_to(:helper2, Salt.User)
    belongs_to(:classtitle, Salt.Classtitle)
    has_many(:registrations, Salt.Registration)
    # belongs_to :student,  Salt.Student
    timestamps()
  end

  @fields [:fallfee, :springfee]

  # if no data - return a blank changeset
  def changeset(class, params \\ %{}) do
    class
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> cast_assoc(:classtitle, required: true)

    # |> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
  end
end
