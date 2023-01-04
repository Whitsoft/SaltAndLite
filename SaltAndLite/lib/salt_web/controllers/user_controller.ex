defmodule SaltWeb.UserController do
  use SaltWeb, :controller
  use SaltWeb.CurrentUser

  # id is primary key value for user table
  def show(conn, %{"id" => id}, _current_user) do
    IO.puts("SHOW USER")
    IO.inspect(id)
    # get a new empty changeset
    user = Salt.get_user(id)
    render(conn, "show.html", user: user)
  end

  #############################################
  # Salt.new_user is a new empty changeset #
  #############################################

  def new(conn, _params, _opts) do
    # get an empty user changeset
    user = Salt.new_user()
    # Trick to insert action into changeset
    user = %{user | action: :create}

    render(conn, "new.html", user: user)
  end

  def create(conn, %{"user" => user_params}, _opts) do
    case Salt.insert_user(user_params) do
      {:ok, user} -> redirect(conn, to: Routes.user_path(conn, :show, user))
      {:error, user} -> render(conn, "new.html", user: user)
    end
  end

  defp prevent_unauthorized_access(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

    requested_user_id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if current_user == nil || current_user.id != requested_user_id do
      IO.puts("page not auth")

      conn
      |> put_flash(:error, "Page not authorized")
      |> redirect(to: Routes.user_path(conn, :new))
      |> halt()
    else
      conn
    end

    # end if
  end

  # end defp
  #######################################################################
  # pattern match on key  labeled "id"                                  #
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder x #
  #######################################################################

  # %{"id" => id}) do
  def edit(conn, _params) do
    IO.puts("MADE IT TO EDIT USER")
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    # changeset
    # profile = Salt.show_profile(userid)
    render(conn, "edit.html", userid: userid)
    # def edit(conn, %{"id" => id}) do
    # IO.puts("edit user")
    # user = Salt.get_user(id)
    # render(conn, "edit.html", user: user)
    # current_user = Map.get(conn.assigns, :current_user)
    # get user id - links to user table
    # userid = current_user.id

    # conn
    ## |> assign(:student, student)
    #  |> assign(:firstname, firstname)
    #  |> assign(:student_id, student_id)
    #  |> assign(:lastname, lastname)
    #  |> assign(:layout, {SaltWeb.LayoutView, "editstudent.html"})
    #  |> render("edit.html")
  end

  def update(conn, %{"id" => id, "user" => params}) do
    # user is a changeset - with data from the users table before updating
    user = Salt.get_user(id)
    # send student changeset along with the map of changes

    case Salt.update_user(user, params) do
      {:ok, _item} -> redirect(conn, to: Routes.user_path(conn, :show, user))
      {:error, _item} -> render(conn, "edit.html", user: user)
    end
  end
end
