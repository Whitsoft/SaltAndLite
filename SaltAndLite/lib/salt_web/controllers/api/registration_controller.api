defmodule SaltWeb.Api.RegistrationController do
  use SaltWeb, :controller
  # import Salt.Student

  plug(:require_logged_in_user)

  alias Salt.{
    Registration,
    Repo
  }

  ####################################################################################
  #                        1. Rendering - maps and lists                             #
  #                            Render from a view                                    #
  # three parameters associated with the render:                                     #
  # the View, the Template, and the “assigns”. The view may be implied.              #
  # Rendering the default view render("index.html", name: "Wintermute")              #
  # Specifying the VIEW render(SprawlWeb.PageView, "index.html", name: "Wintermute") #
  # The last parameter is the “assigns” Map                                          #
  # render("show.html", %{id: 2112, name: "Wintermute"})                             #
  # view's version of render - must manually assign the conn and the file type       #
  # must be specified.                                                               #
  #                                                                                  #
  #                          2. render from a controller                             #
  # %Plug.Conn{} struct plays a significant role. Because of that, the conn variable #
  # needs to be provided to the render/n function.                                   #
  # controller’s version of render sets the conn value in the assigns                #
  # render conn, :index, users: list_of_users or to a differnt view:                 #
  # conn                                                                             #
  #   |> put_view(SprawlWeb.UserView)                                                #
  #   |> render :show, name: "Maelcum", title: "Pilot" - let's use map symbols tho   #
  #                                                                                  #
  #                          3. render from a template                               #
  # render/2 - defaults to current view -- render/3 specifies the view               #
  # <%= render "show.html", name: "Case", occupation: "Hacker" %> (2 parameters)     #
  # <%= render SprawlWeb.SharedView, "sidebar.html", ai_list: ais %> (3 parameters)  #
  # NOTE: can render lists as well as maps                                           #
  # https://samuelmullen.com/articles/phoenix_templates_rendering_and_layouts/       #
  ####################################################################################

  ######################################################################
  #                             ASSIGNS       - lives in conn          #
  # @ is a macro that essentially calls                                #
  # Map.get to get our given key in the template assigns.              #
  ######################################################################

  def delete(conn, %{student_id: student_id, classid: class_id, semester: semester}) do
    IO.puts("REG DELETE")
    id = Salt.get_registration_by_three(student_id, class_id, semester)
    # redirect(conn, to: "/items")
    # id is the registration id
    # Salt.delete_registration(id)

    conn
    |> put_flash(:info, "Class registration deleted successfully.")
    |> redirect(to: Routes.student_registration_path(conn, :index))
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
