defmodule Salt.Period do
  use Ecto.Schema
  import Ecto.Changeset

  :application.get_key(:salt, :modules)

  schema "periods" do
    field(:time, :string)
    has_many(:classes, Salt.Class)
    timestamps()
  end

  @fields [:id, :time]

  # if no data - return a blank changeset
  def changeset(period, params \\ %{}) do
    period
    # cast returns a changeset
    |> cast(params, @fields)
    |> validate_required(@fields)

    # |> assoc_constraint(:student)  # Look for associated records in database - if they don't exist kill the query
  end
end
