defmodule SaltWeb.SessionController do
  use SaltWeb, :controller

  def new(conn, _params) do
    # conn = clear_session(conn)
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Salt.get_user_by_username_and_password(username, password) do
      %Salt.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :show, user))

      _ ->
        conn
        |> put_flash(:error, "That username and password combination can not be found")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    # clear any cookies in the users browser of any data indicating that user is logged in.
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
