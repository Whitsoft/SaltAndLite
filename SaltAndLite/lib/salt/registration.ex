defmodule Salt.Registration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Salt.{Class, Student}

  schema "registrations" do
    # field :student_id,  :integer
    # field :class_id,    :integer
    field :semester, :integer
    # reference registration.class    - class_id is a foreign key
    belongs_to :class, Salt.Class
    # reference registration.students - student_id is a foreign key
    belongs_to :student, Salt.Student
    # :registration_id field comes from registration.id
    # :class_id field comes from class.id
    timestamps()
  end

  @fields [:student_id, :class_id, :semester]

  # if no data - return a blank changeset
  def changeset(registration, params \\ %{}) do
    registration
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:semester, 1..2)
    # Look for associated records in database - if they don't exist kill the query
    |> assoc_constraint(:student)
  end
end
