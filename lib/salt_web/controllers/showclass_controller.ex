defmodule SaltWeb.ShowclassController do
  use SaltWeb, :controller
  alias Salt.Class
  # import Salt.Student

  plug(:require_logged_in_user)

  # plug(:put_layout, false)
  # conn - a plug containing request and response information.

  #***********************************************#
  # show a single class identified by a unique ID #
  # purpose is for editing the class              #
  #***********************************************#

  def index(conn, _params) do
    IO.puts("CLASS CONTROLLER INDEX")
    IO.puts("class title list")
    classtitles = Salt.get_classtitle_list()
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
    |> put_layout("classes.html")
    |> render("index.html")
  end

  #########################
  #  id is a class id     #
  #########################
  def show(conn, %{"id" => id} = _params) do
    IO.puts("SHOWCLASS CONTROLLER SHOW")
    IO.inspect(id)
    #(Map.get(conn.req_cookies, "_csrf_token"))
    # get class from class id - return a list
    classlist   = Salt.list_oneclass_data(id)
    classtitle  = classlist[:classtitle]
    fee         = classlist[:fee]
    period      = classlist[:period]
    section     = classlist[:section]
    semester    = classlist[:semester]
    teacherlist = classlist[:teachername]
    teacher1    = Enum.at(teacherlist,0)
    teacher2    = Enum.at(teacherlist,1)
    teacher3    = Enum.at(teacherlist,2)
    classid     = id

    # get classlist - list of classstructs  with the title corresponding to the title id
    # action = ":edit"
    # use a different layout than app
    conn
      |> assign(:id, id)
      |> assign(:classtitle, classtitle)
      |> assign(:fee, fee)
      |> assign(:period, period)
      |> assign(:section, section)
      |> assign(:semester, semester)
      |> assign(:teacher1, teacher1)
      |> assign(:teacher2, teacher2)
      |> assign(:teacher3, teacher3)
    # |> assign(:changeset, changeset)
      |> assign(:action, Routes.showclass_path(conn, :edit, id))
      |> render("showclass.html")
  end

  def new(conn, _params) do
    class = Salt.new_class()
    role = "teacher"

    classtitles = Salt.get_classtitle_list()

    periods = Salt.get_class_period_list()
    sections = Salt.get_class_section_list()
    teachers = Salt.get_class_teacher_list(role)
    submitter = 1

    conn
    |> assign(:classtitles, classtitles)
    |> assign(:sections, sections)
    |> assign(:periods, periods)
    |> assign(:teachers, teachers)
    |> assign(:submitter, submitter)
    |> render("new.html")
  end

  ######################################################################
  # class is a changeset - class.data is a schema struct               #
  # What did we  request ?  class_params must include key "class"      #
  # class_params may, however, include other keys                      #
  ######################################################################
  def create(conn, %{"class" => class_params}, _opts) do
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid = current_user.id

    # lastname = Salt.get_profile_lastname(userid)

    # insert user :id into student :user_id
    # The Map.put/3 function takes three arguments: a map, a key and a value.
    # It will then return an updated version of the original map.
    # user_id was not provided by the form
    classparams = Map.put(class_params, "user_id", userid)
    # %Student{}#Salt.Student

    class_changeset = Class.changeset(%Class{}, classparams)
    class_insert = Salt.insert_class(class_changeset.changes)

    case class_insert do
      {:ok, class_insert} ->
        conn
        |> put_flash(:info, "Class created successfully.")
        |> redirect(to: Routes.class_path(conn, :show, class_insert))

      {:error, %Ecto.Changeset{} = class_changeset} ->
        render(conn, "index.html", class_changeset: class_changeset)
    end
  end

  # show_classes needs fixed
  # students = Salt.show_classes(userid).classes #students is a list of structs
  # render(conn, "index.html", students: students ,lastname: last_name,##
  # layout: {SaltWeb.LayoutView, "indexstudent.html"})
  def edit(conn, %{"id" => id}) do
    IO.inspect(id)
    IO.puts("SHOW CLASS CONTROLLER EDIT")
    role = "teacher"
    class = Salt.show_class(id)

    classlist    = Salt.list_oneclass_data(id)
    |> IO.inspect()
    IO.puts("CLASSLIST INSPECTED")
    classtitle   = classlist[:classtitle]
    section      = classlist[:section]
    period       = classlist[:period]
    fee          = classlist[:fee]
    semester     = classlist[:semester]
    teacherlist  = classlist[:teachername]
    teacher1     = Enum.at(teacherlist,0)
    teacher2     = Enum.at(teacherlist,1)
    teacher3     = Enum.at(teacherlist,2)

    sections   = Salt.get_class_section_list()
    periods    = Salt.get_class_period_list()
    teachers   = Salt.get_class_teacher_list(role)

    conn
       |> assign(:id, id)
       |> assign(:class, class)
       |> assign(:classtitle, classtitle)
       |> assign(:section,    section)
       |> assign(:period,     period)
       |> assign(:fee,        fee)
       |> assign(:semester,   semester)
       |> assign(:teacher1,   teacher1)
       |> assign(:teacher2,   teacher2)
       |> assign(:teacher3,   teacher3)

       |> assign(:sections,   sections)
       |> assign(:periods,    periods)
       |> assign(:teachers,   teachers)

       |> assign(:action, Routes.showclass_path(conn,:update, id))
       |> put_layout("blank.html")
       |> render("sedit.html")
  end

  def update(conn, %{ "class" => updates}) do
    IO.puts("NOW WE ARE IN SHOWCLASS UPDATE")
    atom_updates = Salt.key_to_atom(updates)
    id = atom_updates.class_id
    class = Salt.get_class(id)
    new_updates = Salt.transform_class_updates(class, atom_updates)
    |> IO.inspect()
    IO.puts("GOING TO UPDATE+CLASS")
    case Salt.update_class(class, new_updates) do
      {:ok, _item} -> redirect(conn, to: Routes.showclass_path(conn, :show, id))
      {:error, _item} -> render(conn, "sedit.html", class: class)
    end
  end

  def singleclass(conn, %{"id" => id}) do
    IO.puts("SINGLE CLASS")
    IO.inspect(id)
  end

  # Pattern match to determine that there is no current user
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to create a student.")
    |> redirect(to: Routes.profile_path(conn, :show))
    |> halt()
  end

  @spec package_classes_data(any) :: nil
  defp package_classes_data(classtitle_id) do
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
