defmodule Salt.Section do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sections" do
    field :description, :string
    timestamps()
  end

  @fields [:descrition]

  # if no data - return a blank changeset
  def changeset(section, params \\ %{}) do
    section
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
