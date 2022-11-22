defmodule SaltWeb.UserController do
  use SaltWeb, :controller
  use SaltWeb.CurrentUser

  plug :prevent_unauthorized_access when action in [:show]

  # def show(conn, _params, current_user) do
  #  render(conn, "show.html", logged_in: current_user)
  # end

  # id is primary key value for user table
  def show(conn, %{"id" => id}, current_user) do
    user = Salt.get_user(id)
    render(conn, "show.html", user: user)
  end

  Salt

  def new(conn, _params, _opts) do
    IO.puts("NEW")
    user = Salt.new_user()
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
end
