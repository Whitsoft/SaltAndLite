defmodule Salt.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registrations" do
    # field :student_id,  :integer
    # field :class_id,    :integer
    field(:semester, :integer)
    # reference registration.class    - class_id is a foreign key
    belongs_to(:class, Salt.Class)
    # reference registration.students - student_id is a foreign key
    belongs_to(:student, Salt.Student)
    # :registration_id field comes from registration.id
    # :class_id field comes from class.id
    timestamps()
  end

  @fields [:class_id, :semester, :student_id]
  # %{"class_id" => "27", "semester" => "1", "student_id" => "29"}

  # if no data - return a blank changeset
  def changeset(registration, params \\ %{}) do
    IO.inspect(params)
    IO.puts("Registration schema")
    # %{"class_id" => "27", "semester" => "1", "student_id" => "29"}
    registration
    # cast returns a changeset
    |> cast(params, @fields)
    #|#> cast_assoc(params, :classid)
    #|> cast_assoc(params, :studentid)
    |> validate_required(@fields)
    |> validate_inclusion(:semester, 1..2)

    # Look for associated records in database - if they don't exist kill the query
    |> assoc_constraint(:student)
  end
end
