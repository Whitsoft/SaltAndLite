defmodule Salt.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  # %Salt.Profile{} is an empty schema struct

  schema "profiles" do
    field(:title, :string)
    field(:lastname, :string)
    field(:firstname, :string)
    field(:spousename, :string)
    field(:streetaddress, :string)
    field(:city, :string)
    field(:state, :string)
    field(:zipcode, :string)
    field(:phoneone, :string)
    field(:phonetwo, :string)

    belongs_to(:user, Salt.User)
    timestamps()
  end

  @fields [
    :title,
    :lastname,
    :firstname,
    :spousename,
    :streetaddress,
    :city,
    :state,
    :zipcode,
    :phoneone,
    :phonetwo,
    :user_id
  ]

  ###############################################################################
  # profile is a struct as laid out in the "profiles" schema                    #
  # Most Ecto.changeset functions accept either a struct or a changeset struct  #
  ###############################################################################

  # data is a key, value pair - put the data into the changeset
  def changeset(profile, data \\ %{}) do
    profile
    # cast returns a changeset, @fields is a list
    |> cast(data, @fields)
    |> validate_required([:lastname, :firstname, :user_id])
    # Look for associated records in database - if they don't exist kill the query
    |> assoc_constraint(:user)

    # tell ecto that there's a unique constraint
    |> unique_constraint(:my_constraint, name: :my_index)
  end
end

# changeset = User.changeset(%User{}, %{age: 0, email: "mary@example.com"})

# defmodule User do
#  use Ecto.Schema
#  import Ecto.Changeset

#  schema "users" do
#    field :name
#    field :email
#    field :age, :integer
#  end

#  def changeset(user,data \\ %{}) do
#    user
#    |> cast(data, [:name, :email, :age])
#    |> validate_required([:name, :email])
#    |> validate_format(:email, ~r/@/)
#    |> validate_inclusion(:age, 18..100)
#    |> unique_constraint(:email)
#  end
# end
