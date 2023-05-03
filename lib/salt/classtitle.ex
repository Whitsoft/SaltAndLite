defmodule Salt.Classtitle do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Salt.{Class, Classtitle}

  schema "classtitles" do
    field(:description, :string)
    field(:syllabus, :string)
    has_many(:classes, Salt.Class)
    timestamps()
  end

  @fields [:id, :description, :syllabus]

  def changeset(classtitle, params \\ %{}) do
    classtitle
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end

# If we look at the cast/3, we can see that it will take
# 1. our struct
# 2. our params map
# 3. and a list of allowed fields,
#    and returns a changeset struct that is either valid or invalid.
#    It is valid if all of the allowed fields (the 3rd argument to the function) were able to be successfully converted
#        to their respective type according the struct given to it.
#    (The function can work on other data as well, but let’s   keep things simple).

# def changeset - marks the changset as valid if all the fields in the second argument are present in the changeset.
# It marks the changeset invalid if any one of the fields is missing,
# adding the correct message(s) to the errors field of the changeset.
