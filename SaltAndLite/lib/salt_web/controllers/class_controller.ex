defmodule SaltWeb.ClassController do
  use SaltWeb, :controller
  import SaltWeb.Router.Helpers
  alias Salt.Class
  # import Salt.Student

  plug(:require_logged_in_user)

  # conn - a plug containing request and response information.
  def new(conn, _params) do
    class = Salt.new_class()
    # , conn: conn)
    render(conn, "new.html", class: class)
  end

  def index(conn, %{"classtitle_id" => classtitle_id}) do
    IO.puts("MADE IT TO INDEX")
    class = Salt.get_class_from_title(classtitle_id)
    # function x
    classes = Enum.map(class, fn x -> package_classes_data(classtitle_id) end)

    classtitle_list = Salt.get_classtitles()
    # show_classes needs fixed
    # students = Salt.show_classes(userid).classes #students is a list of structs
    # render(conn, "index.html", students: students ,lastname: last_name,##
    # layout: {SaltWeb.LayoutView, "indexstudent.html"})
  end

  @spec package_classes_data(any) :: nil
  def package_classes_data(classtitle_id) do
    # classdata =       Salt.get_class_from_classid(classid)
    # classtitle =      regdata.classtitle.description
    # fallfee =         regdata.fallfee
    # springfee =       regdata.springfee
    # fee =             Salt.get_fee(semester, fallfee, springfee)
    # section =         regdata.section.description
    # period =          regdata.period.time
    # teachername =     Salt.get_teacher_name(regdata.teacher.id)
    # helper1name =     Salt.get_teacher_name(regdata.helper1.id)
    # helper2name =     Salt.get_teacher_name(regdata.helper2.id)
    # list = [classtitle,section,period,fee,semester,teachername,helper1name,helper2name]
  end

  #########################
  #  id is a classtitle   #
  #########################
  def show(conn, %{"id" => id} = _params) do
    IO.inspect(Map.get(conn.req_cookies, "_csrf_token"))
    # changeset
    # get class title from title id
    classtitle = Salt.get_class_title(id)
    # get classlist - classes with the title corresponding to the title id
    classlist = Salt.get_class_from_title(id)
    IO.puts("CLASSCLONTOLLER SHOW")
    # classes:  a list- of sub lists, each sublist contains info for the particular class
    # classes = Enum.map(classlist, fn x -> Salt.list_class_data(x.id, x.semester) end)
    # use a different layout than app
    conn
    # Ex: "Study Hall"
    |> assign(:id, id)
    |> assign(:title, classtitle.description)
    |> assign(:classes, classlist)
    # display a web page to select a particular class
    |> render("show.html")
  end

  # _ \\ %{}) do #%{"id" => id}) do #%{"id" => id}) do
  def edit(conn, %{"id" => id}) do
    current_user = Map.get(conn.assigns, :current_user)
    # get user id - links to user table
    userid = current_user.id
    # get student changeset by student.id  - firstname, grade, birthday
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

  def update(conn, student_params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    student = Salt.get_student(userid)
    student_id = student.data.id
    firstname = student.data.firstname
    lastname = Salt.get_student_profile(userid)
    lastname = lastname.data.lastname
    # params = Salt.Student.changeset(student_params)
    case Salt.update_student(student, student_params) do
      {:ok, student} ->
        redirect(conn, to: Routes.student_path(conn, :show, student))

      {:error, student} ->
        render(conn, "edit.html",
          student: student,
          conn: conn,
          firstname: firstname,
          lastname: lastname,
          student_id: student_id,
          layout: {SaltWeb.LayoutView, "editstudent.html"}
        )
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
