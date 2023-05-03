defmodule SaltWeb.SelectclassController do
  use SaltWeb, :controller

  alias Salt.{
    Registration
  }

  #######################################################
  # use SaltWeb, :controller is from lib/SaltWeb module #
  # includes                                            #
  # use Phoenix.Controller, namespace: SaltWeb          #
  # import Plug.Conn                                    #
  # alias SaltWeb.Router.Helpers, as: Routes            #
  #######################################################
  import SaltWeb.Router.Helpers
  # import Salt.Student

  # plug :action
  # plug(:require_logged_in_user)

  # alias Salt.{
  #   Class
  # }
  # "class_id" => " 25 ", "semester" => " 1 ", "student_id" => "29"}
  def create(conn,params) do
    # take away "_csrf_token" from params
    map = Map.delete(params, "_csrf_token")
    IO.inspect(map)
    studentid = String.to_integer(params["student_id"])
    semester  = params["semester"]
    map = Map.put(map,"student_id", studentid)
    map = Map.put(map,"semester", semester)
    |> IO.inspect()
    IO.puts("ID as integer")
    registration_changeset = Registration.changeset(%Registration{}, map)
    |> IO.inspect()
    IO.puts("HI")
    registration_insert = Salt.insert_registration(registration_changeset.changes)

    case registration_insert do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: Routes.student_registration_path(conn, :index, studentid))

      {:error, registration} ->
        render(conn, "new.html", registration: registration)
    end
  end

  ################################################################
  # get all classes for classtitle id = id                       #
  # In this case it may be multiple classes rather than just one #
  ################################################################
  def show(conn, %{"id" => id}) do
    IO.inspect(id)
    IO.puts("ID INSPECTED")
    IO.puts("selectclass_controller SHOW")
    changeset = Salt.blank_new_registration()
    classtitle = Salt.get_classtitle(id).description
    classes  = Salt.build_class_list(id)

    conn
    |> assign(:changeset, changeset)
    |> assign(:id, id)
    |> assign(:classtitle, classtitle)
    |> assign(:classes, classes)
    |> put_layout("generic.html")
    |> render("show.html")
  end
end
