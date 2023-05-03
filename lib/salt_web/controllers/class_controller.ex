defmodule SaltWeb.ClassController do
  use SaltWeb, :controller
  alias Salt.Class
  alias SaltWeb.Router.Helpers, as: Routes
  # import Salt.Student

  plug(:require_logged_in_user)

  plug(:put_layout, false)
  # conn - a plug containing request and response information.

  def index(conn, _params) do
    ################################################################################
    # titlelist is a list of list of lists - containing ALL available class titles #
    # strictly analogous to classes in registration controller def index(xxx)      #
    ################################################################################
    role = "teacher"

    classtitles = Salt.get_classtitle_list()
    sections = Salt.get_class_section_list()
    periods = Salt.get_class_period_list()
    teachers = Salt.get_class_teacher_list(role)
    conn
    |> assign(:classtitles, classtitles)
    |> assign(:sections, sections)
    |> assign(:periods, periods)
    |> assign(:teachers, teachers)
    # |> assign(:layout, {SaltWeb.LayoutView, "classes.html"})
    |> render("index.html", layout: {SaltWeb.LayoutView, "classes.html"})
  end

  # show_classes needs fixed
  # students = Salt.show_classes(userid).classes #students is a list of structs
  # render(conn, "index.html", students: students ,lastname: last_name,##
  # layout: {SaltWeb.LayoutView, "indexstudent.html"})

  @spec package_classes_data(any) :: nil
  def package_classes_data(classtitle_id) do
    # classdata =       Salt.get_class_from_classid(classid)
    # classtitle =      regdata.classtitle.description
    # fallfee =         regdata.fallfee
    # springfee =       regdata.springfee
    # fee =             Salt.get_fee(semester, fallfee, springfee)
    # section =         regdata.section.description
    # period =          regdata.period.time
    # teacher1name =     Salt.get_teacher_name(regdata.teacher1.id)
    # teacher2name =     Salt.get_teacher_name(regdata.teacher2.id)
    # teacher3name =     Salt.get_teacher_name(regdata.teacher3.id)
    # list = [classtitle,section,period,fee,semester,teacher1name,teacher2name,teacher3name]
  end

  #########################
  #  id is a classtitle   #
  #########################
  def show(conn, %{"id" => id} = _params) do
    IO.inspect(id)
    IO.puts("CLASS_CONTROLLER SHOW")
    # IO.inspect(Map.get(conn.req_cookies, "_csrf_token"))
    # get  id of classtitle drom class.classtitle_id
    IO.puts("RUN THRU CLASS SHOW")
    class = Salt.get_classtitle(id)
    |> IO.inspect()
    classtitle = Salt.get_classtitle(id)
    classlist = Salt.get_classes_from_title(id)
    |> IO.inspect()
    classlist = Salt.get_classes_from_title(id)
      conn
        |> assign(:id, id)
        |> assign(:class, class)
        |> assign(:title, classtitle.description)
        |> assign(:classes, classlist)
        |> render("show.html")
  end

  def new(conn, _params) do
    IO.puts("CLASS CONTROLLER NEW")
    class = Salt.new_class()
    role = "teacher"

    classtitles = Salt.get_classtitle_list()

    periods = Salt.get_class_period_list()
    sections = Salt.get_class_section_list()
    teachers = Salt.get_class_teacher_list(role)
    submitter = 1

    conn
    |> assign(:class, class)
    |> assign(:classtitles, classtitles)
    |> assign(:sections, sections)
    |> assign(:periods, periods)
    |> assign(:teachers, teachers)
    |> assign(:submitter, submitter)
    |> assign(:action, Routes.class_path(conn, :create))
    |> render("new.html")
  end

  ######################################################################
  # class is a changeset - class.data is a schema struct               #
  # What did we  request ?  student_params must include key "class"    #
  # class_params may, however, include other keys                      #
  ######################################################################
  def create(conn, %{"class" => class_params}) do
    params = Salt.inject_teachers(class_params)

    class_changeset =
      Class.changeset(%Class{}, params)

    IO.puts("CLASS PARAMS INSPECTED")
    class_insert = Salt.insert_class(class_changeset.changes)

    case class_insert do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class created successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", class_changeset: class_changeset)
    end
  end

  # _ \\ %{}) do #%{"id" => id}) do #%{"id" => id}) do
  def edit(conn, %{"id" => id}) do
    class = Salt.show_class(id)
    class_id = class.data.id
    # firstname = student.data.firstname
    # lastname is contained in profile belonging to user
    # lastname = Salt.get_student_profile(userid)
    # lastname = lastname.data.lastname
    render(conn, "edit.html",
      class: class,
      conn: conn,
      class_id: class_id,
      layout: {SaltWeb.LayoutView, "editclass.html"}
    )
  end

  def update(conn, %{"id" => id, "class" => params}) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    # params = Salt.Student.changeset(student_params)
    class = Salt.get_class(id)
    IO.puts("class controller going to showclass show")
    case Salt.update_class(class, params) do
      {:ok, _item} -> redirect(conn, to: Routes.showclass_path(conn, :show, class))
      {:error, _item} -> render(conn, "edit.html", class: class)
    end
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
