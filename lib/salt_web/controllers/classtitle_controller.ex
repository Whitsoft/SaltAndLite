defmodule SaltWeb.ClasstitleController do
  use SaltWeb, :controller
  alias Salt.Classtitle
  # import Salt.Student
  plug(:require_logged_in_user)
  # plug(:put_layout, {SaltWeb.LayoutView, "index.html"})
  # conn - a plug containing request and response information.

  def index(conn, _params) do
    classtitles = Salt.get_classtitle_list()
    ################################################################################
    # titlelist is a list of list of lists - containing ALL available class titles #
    # strictly analogous to classes in registration controller def index(xxx)      #
    ################################################################################
    current_user = Map.get(conn.assigns, :current_user)
    who = Salt.is_teacher(current_user.roles) or Salt.is_administrator(current_user.roles)
    layout = Salt.choose_from_two(who, "aindexclasstitle.html", "uindexclasstitle.html")

    conn
    |> assign(:classtitles, classtitles)
    |> put_layout(layout)
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    # classtitle is a changeset - returned by Salt
    classtitle = Salt.show_classtitle(id)
    submitter = nil

    conn
    |> assign(:id, id)
    |> assign(:classtitle, classtitle)
    |> assign(:submitter, submitter)
    |> assign(:action, Routes.classtitle_path(conn, :create))
    |> put_layout("generic.html")
    # |> assign(:layout, {SaltWeb.LayoutView, "showclasstitle.html"})
    |> render("show.html")
  end

  def new(conn, _params) do
    # classtitle is a blank changeset - returned Salt
    classtitle = Salt.new_classtitle()
    submitter = 1

    # render(conn, "new.html",
    # submitter: submitter,
    #  classtitle: classtitle,
    #  action: Routes.classtitle_path(conn, :create)
    # )

    conn
    |> assign(:submitter, submitter)
    |> assign(:classtitle, classtitle)
    |> assign(:action, Routes.classtitle_path(conn, :create))
    |> put_layout("generic.html")
    |> render("new.html")

    # render(conn, "new.html")
  end

  #  %{}) do #%{"id" => id}) do #%{"id" => id}) do
  def edit(conn, %{"id" => id}) do
    classtitle = Salt.show_classtitle(id)
    title_id = String.to_integer(id)
    submitter = 1
    action = ":update"

    conn
    |> assign(:classtitle, classtitle)
    |> assign(:title_id, title_id)
    |> assign(:submitter, submitter)
    |> assign(:action, action)
    |> put_layout("generic.html")
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "classtitle" => params}) do
    classtitle = Salt.get_classtitle(id)

    case Salt.update_classtitle(classtitle, params) do
      {:ok, classtitle} ->
        # put_flash(:info, "Class title updated successfully.")
        redirect(conn, to: Routes.classtitle_path(conn, :show, classtitle))

      {:error, _item} ->
        render(conn, "edit.html", classtitle: classtitle)
    end
  end

  def delete(conn, %{"id" => id}) do
    Salt.delete_classtitle(id)

    conn
    |> put_flash(:info, "Class registration deleted successfully.")
    |> redirect(to: Routes.classtitle_path(conn, :index))
  end

  # Pattern match to determine that there is no current user
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to create a student.")
    |> redirect(to: Routes.profile_path(conn, :show))
    |> halt()
  end

  # Pass on the conn because there is a current user
  defp require_logged_in_user(conn, _opts), do: conn
end
