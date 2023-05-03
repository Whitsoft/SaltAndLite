defmodule SaltWeb.StudentController do
  use SaltWeb, :controller
  use SaltWeb.CurrentUser
  alias Salt.Student

  # plug(:put_layout, {SaltWeb.LayoutView, "showstudent.html"})

  # @profile_map = %{title: title, lastname: lastname, firstname: firstname, spousename: spousename, streetaddress: streetaddress, city: city,
  # state: state, zipcode: zipcode, phoneone: phoneone, phonetwo: phonetwo}

  def index(conn, _params, _opts) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Salt.get_user_lastname(userid)
    # students is a map  salt.User - it includes a LIST of student maps
    students = Salt.show_students(userid)

    conn
    |> assign(:user_id, userid)
    |> assign(:students, students)
    |> assign(:lastname, lastname)
    |> put_layout("indexstudent.html")
    |> render("index.html")
  end

  ##############################################################
  # student is a changeset - student.data is a schema struct   #
  # Obtained student_id from the id: field in the struct       #
  # What did we  request ?  id param must include key "id"     #
  # Suppose no id was supplied or perhaps user_id was supplied #
  # %{"id" => id} pattern match - id must match string "id"    #
  ##############################################################
  def show(conn, %{"id" => id}, _opts) do
    # _opts is the user changeset (parent of student)
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Salt.get_user_lastname(userid)
    # student is a changeset
    student = Salt.show_student(id)
    # actual id in student table
    student_id = student.data.id
    |> IO.inspect()
    IO.puts("student_id")
    conn
    |> assign(:student, student)
    |> assign(:student_id, student_id)
    |> assign(:lastname, lastname)
    |> put_layout("showstudent.html")
    |> render("show.html")
  end

  # conn - a plug containing request and response information.

  #############################################
  # Salt.new_student is a new empty changeset #
  #############################################
  def new(conn, _params, _opts) do
    # get an empty student changeset
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Salt.get_user_lastname(userid)
    student = Salt.new_student()
    # action: is nil
    #submitter = 1
    # get user_id from conn
    userid = Map.get(conn.assigns, :current_user).id
    IO.inspect(userid)
    # Cool trick to replace changeset  action: :nil with action: :create
    student = %{student | action: :create}
    IO.inspect(student.data)
    # student = %{student.data | id: :0}
    student = Ecto.Changeset.put_change(student, :user_id, userid)
    # student_path  POST    /students  SaltWeb.StudentController :create - from router
    # action = Routes.student_path(conn, :create)

    conn
    |> assign(:student, student)
    |> assign(:lastname, lastname)
    |> put_layout("generic.html")
    |> render("new.html")
  end

  ######################################################################
  # student is a changeset - student.data is a schema struct           #
  # What did we  request ?  student_params must include key "student"  #
  # student_params may, however, include other keys                    #
  ######################################################################
  def create(conn, %{"student" => student_params}, _opts) do
    # from a Map - get the value for a key - in this case from conn.assigns
    current_user = Map.get(conn.assigns, :current_user)
    # get current_user.id
    userid = current_user.id

    # lastname = Salt.get_profile_lastname(userid)

    # insert user :id into student_changeset :user_id
    # The Map.put/3 function takes three arguments: a map, a key and a value.
    # It will then return an updated version of the original map.
    # user_id was not provided by the form
    studentparams = Map.put(student_params, "user_id", userid)
    # %Student{}#Salt.Student

    student_changeset =
      Student.changeset(%Student{}, studentparams)
      |> IO.inspect()

    student_insert = Salt.insert_student(student_changeset.changes)

    case student_insert do
      {:ok, student_insert} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student_insert))

      {:error, %Ecto.Changeset{} = student_changeset} ->
        render(conn, "new.html", student_changeset: student_changeset)
    end
  end

  #######################################################################
  # pattern match on key  labeled "id"                                  #
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder x #
  #######################################################################

  def edit(conn, %{"id" => id}, _opts) do
    current_user = Map.get(conn.assigns, :current_user)
    # get user id - links to user table
    userid = current_user.id
    # get student changeset by student.id  - firstname, grade, birthday
    # student is a changeset presumabley empty
    student = Salt.show_student(id)

    student_id = student.data.id
    firstname = student.data.firstname
    # lastname is contained in profile belonging to user
    lastname = Salt.get_user_lastname(userid)
    # lastname = lastname.data.lastname
    method = :GET

    conn
    |> assign(:student, student)
    |> assign(:firstname, firstname)
    |> assign(:student_id, student_id)
    |> assign(:lastname, lastname)
    |> assign(:student, student)
    |> assign(:method, method)
    |> put_layout("generic.html")
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "student" => params}, _opts) do
    # params example %{"birthday" => "2002-12-02", "firstname" => "Owen", "grade" => "12"}
    # student is not a changeset  - but a schema struct
    student = Salt.get_student(id)
    # send student changeset along with the map of changes

    case Salt.update_student(student, params) do
      {:ok, _item} -> redirect(conn, to: Routes.student_path(conn, :show, student))
      {:error, _item} -> render(conn, "edit.html", student: student)
    end
  end

  def delete(conn, %{"id" => id}, _params) do
    sid = String.to_integer(id)
    IO.inspect(sid)
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    IO.puts("inspect student")
    student = Salt.show_student(id)
    IO.inspect(student.data)
    student_id = String.to_integer(id)
    firstname = student.data.firstname
    lastname = Salt.get_user_lastname(userid)
    regcount = Salt.count_student_registrations(sid)

    if regcount > 0 do
      conn
        |> put_flash(:info, "There are "<> Integer.to_string(regcount) <> "registrations for ")
        |> put_flash(:info, "These registrations must be deleted first.")
        |> redirect(to: Routes.student_registration_path(conn, :index, id))
    else
      Salt.delete_student(student_id)
      conn
        |> put_flash(:info, "Student " <> firstname <> " " <> lastname <> " has been deleted")
        |> redirect(to: Routes.user_path(conn, :show, userid))
    end
  end

  # Pattern match to determine that there is no current user
  # defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
  #  conn
  #  |> put_flash(:error, "You must be logged in to create a student.")
  #   |> redirect(to: Routes.profile_path(conn, :show))
  #   |> halt()
  # end

  # Pass on the conn because there is a current user
  defp require_logged_in_user(conn, _opts), do: conn
end
