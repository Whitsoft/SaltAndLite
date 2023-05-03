defmodule Salt.Class do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Salt.Registration

  schema "classes" do
    field(:fee, :float)
    field(:semester, :integer)
    field(:teacher, {:array, :string})
    belongs_to(:period, Salt.Period)
    belongs_to(:section, Salt.Section)
    belongs_to(:classtitle, Salt.Classtitle)
    has_many(:registrations, Salt.Registration)
    # belongs_to :student,  Salt.Student
    timestamps()
  end

  @fields [:fee, :semester, :teacher, :period_id, :section_id, :classtitle_id]
  @required_fields [:semester, :period_id, :section_id, :classtitle_id, :teacher]

  # if no data - return a blank changeset
  def changeset(class, params \\ %{}) do
    class
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_inclusion(:semester, 1..2)
    |> validate_required(@required_fields)
  end
end
