defmodule SaltWeb.RegistrationController do
  use SaltWeb, :controller

  # import Salt.Student

  plug(:require_logged_in_user)

  alias Salt.{
    Registration
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

  ######################################################################
  # registration is a changeset - registration.data is a schema struct #
  # Obtained registration_id from the id: field in the struct          #
  # map construction 1. %{"student_id" => "30}                         #
  # 2. %{student_id: "30}    - not garbase collected                   #
  # 3. %{student_id: => "30} - similar to 1.                           #
  ######################################################################
  # conn - a plug containing request and response information.

  ########################################################
  # list registrations for student - input as student_id #
  ########################################################
  def index(conn, %{"student_id" => student_id} = params) do
    firstname = Salt.get_student(student_id).firstname
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    lastname = Salt.get_user_lastname(userid)
    # regs.id is registration id, regs.class_id exists also
    regs = Salt.get_student_registrations(student_id)
    classes = Enum.map(regs, fn x -> Salt.list_class_data(x.id, x.class_id, x.semester) end)
    #########################################################################
    # regs is a list of changesets - one for each class registered          #
    # regs contains the classes registered to the student                   #
    # classes is a list of lists - containing ALL available classes         #
    # each sub list is a list [id, classid,period,section, etc]             #
    #########################################################################

    # get a list of classtitles id, description  sans syllabi
    titlelist = Salt.get_classtitle_list()
    # such as [[30, "American History", " "],...]

    # look for @titlelist in index template
    conn
    |> assign(:registrations, regs)
    |> assign(:class_params, params)
    |> assign(:titlelist, titlelist)
    |> assign(:student_id, student_id)
    |> assign(:firstname, firstname)
    |> assign(:lastname, lastname)
    |> assign(:classes, classes)
    |> put_layout("uindexclasstitle.html")
    |> render("index.html")
  end

  # registration id
  def show(conn, %{"id" => id}) do
    current_user = Map.get(conn.assigns, :current_user)
    student_id = Salt.get_student_id_from_registration(id)
    student = Salt.get_student(student_id)
    user_id = Map.get(student, :user_id)
    regdata = Salt.get_class_from_registration(id)

    # reg_list = Salt.get_registration_by_one(student_id)

    # registration_id = reg_list.id0
    classtitle = regdata.classtitle.description
    semester = regdata.semester
    fee = Salt.get_fee(regdata.fee)
    section = regdata.section.description
    period = regdata.period.time

    lastname = Salt.get_user_lastname(user_id)
    # student is a changeset
    student = Salt.show_student(student_id)
    firstname = student.data.firstname
    student_name = Enum.join([firstname, lastname], " ")
    # assign student to @student and student_id to @student_id and lastname to @lastname

    conn
      |> assign(:student_name, student_name)
      |> assign(:student, student)
      |> assign(:student_id, student_id)
      |> assign(:current_user, current_user)
      |> assign(:classtitle, classtitle)
      |> assign(:semester, semester)
      |> assign(:section, section)
      |> assign(:period, period)
      |> assign(:fee, fee)
      |> put_layout("studentindex.html")
      |> render("selectclass.html")
  end

  def new(conn, _params) do
    # changeset = Registration.changeset(%Registration{})
    # Registration is aliased to Salt.Registration
    registration = Salt.Registration.changeset(%Registration{})
    registration = %{registration | action: :create}
    # ex: %{"student_id" => "30"}
    #
    # a blank changeset obtained thru salt.ex - salt/registration.ex
    # registration = Salt.new_registration(params)

    # conn
    # |> assign(:student_id, student_id)
    # |> assign(:firstname, firstname)
    # |> assign(:lastname, lastname)

    render(conn, "new.html",
      registration: registration
      # firstname: firstname,
      # lastname: lastname,
      # student_id: student_id
    )
  end

  #################################################################################################################################
  # The first detail we’ll look at in show/2 is the function definition: def show(conn, %{"id" ⇒ id}) do.                         #
  # We can see that show is going to be passed two parameters, conn and a Map.                                                    #
  # Every function in the controller expects the same by default: a conn and a Map.                                               #
  # The Map is actually a Map of the request parameters from the user.                                                            #
  # While there could be a large number of parameters that get passed into the request by the site visitor,                       #
  # the only one we care about in show is the id param so we use pattern matching to pull out the id from the parameter Map.      #
  # If you’ll remember from our list of routes, /posts/:id is the path that gets us to this function.                             #
  # The ":id" portion of that route specifies that whatever we put into that position will be passed as the id in the params Map. #
  #################################################################################################################################

  #######################################################################
  # Note. The fat arrow designates a key => value pair within a map.    #
  # where the name of the map is assigned to the variable placeholder   #
  # Create - recieve the parameters needed for one new registration     #
  #  and then saves the registration to the data store.                 #
  # Need only - (1) student_id, (2) class_id , (3) semester             #
  #######################################################################

  def create(conn, %{"classid" => params}) do
    student = Map.get(params, "student_id")
    registration_changeset = Registration.changeset(%Registration{}, params)
    registration_insert = Salt.insert_registration(registration_changeset.changes)

    case registration_insert do
      {:ok, registration} ->
        conn
        |> put_flash(:info, "Registration created successfully.")
        |> redirect(to: Routes.student_registration_path(conn, :index, student))

      {:error, registration} ->
        render(conn, "new.html", registration: registration)
    end
  end

  def delete(conn, %{"id" => id}) do
    Salt.delete_registration(id)

    conn
    |> put_flash(:info, "Class registration deleted successfully.")

    # |> redirect(to: Routes.student_registration_path(conn, :index))
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
