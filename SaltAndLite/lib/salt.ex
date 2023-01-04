defmodule Salt do
  alias Salt.{Repo, User, Password, Profile, Student, Class, Classtitle, Registration}
  import Ecto.Query
  @repo Repo

  @moduledoc """
  Salt keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  #######################################
  # conversion functions  - struct / map #
  ########################################
  def schema_to_map(schema) do
    schema
    |> Map.from_struct()
    |> Map.drop([:__meta__])
  end

  ########################################
  # map string key to map atom key       #
  ########################################
  def key_to_atom(string_map) do
    for {key, val} <- string_map, into: %{} do
      {String.to_atom(key), val}
    end
  end

  ################################################################
  # User functions  - for users on Phoenix side of umbrella      #
  ################################################################

  def get_user(id) do
    # returns %Salt.User{User info}
    # given a  user id such as 67
    # return a user changeset
    @repo.get!(User, id)
    # |> preload(profiles: :firstname)
  end

  # Get an empty changeset
  def new_user do
    User.changeset_with_password(%User{})
  end

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  def get_user_by_username_and_password(username, password) do
    # false

    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      # true user will be changeset
      user
    else
      _ -> Password.dummy_verify()
    end

    # Password.verify
  end

  # def

  def get_user_lastname(id) do
    prid = Salt.get_user(id)
    nilprofile = Repo.preload(prid, :profiles).profiles

    case nilprofile do
      # check_nil()
      nil -> nil
      _ -> nilprofile.lastname
    end

    # Repo.get!(Profile, id).lastname
  end

  def update_user(%Salt.User{} = user, updates) do
    user
    |> Salt.User.changeset(updates)
    |> @repo.update()
  end

  #################################################################
  # Profile functions  - for profiles on Phoenix side of umbrella #
  #################################################################
  def new_profile do
    # Return a blank changeset
    Profile.changeset(%Profile{})
  end

  ##########################################################################
  # Alternately Salt.Profile |> struct() in place of %Profile{}         #
  # %Profile{} is a struct - Kernel.struct/2 changes a map to a struct     #
  # changeset/2 - arg 1 is a struct, arg2 is a map of attributes           #
  # Attributes - need to be verified and updated - default is an empty map #
  ##########################################################################
  def insert_profile(params) do
    # Salt.Profile
    %Profile{}
    |> Profile.changeset(params)
    |> @repo.insert()
  end

  ##################################
  # returns a schema struct or nil #
  ##################################

  # Given a user id - return the user profile
  def get_profile(id) do
    @repo.get(Profile, get_profile_id(id))
  end

  # Given user id return the user profile id
  # seems crude  - is there a better way?
  def get_profile_id(userid) do
    query = from(Profile, where: [user_id: ^userid], select: [:id])

    Repo.all(query)
    |> Enum.at(0)
    |> Map.get(:id)
  end

  # Given user id return the user lastname  # seems crude  - is there a better way?
  def get_profile_lastname(userid) do
    query = from(Profile, where: [user_id: ^userid], select: [:lastname])

    Repo.all(query)
    |> Enum.at(0)
    |> Map.get(:lastname)
  end

  # Given a profile id return the user profile
  def get_profile_nil(id) do
    @repo.get(Profile, id)
  end

  # Given user id return a user profile changeset
  # get profile given profile ID
  def show_profile(id) do
    # convert to changeset
    get_profile(id)
    |> Profile.changeset()
  end

  def check_nil() do
    nil
  end

  # stuff = Student.changeset(%Student{}, studentparams)
  # check if there is a profile - for user ID
  def check_profile(id) do
    prid = Salt.get_user(id)
    # If there exists a profile - nilprofile will be a profile struct
    # If ther is no profile     - nilprofile will be nil
    nilprofile = Repo.preload(prid, :profiles).profiles

    case nilprofile do
      # check_nil()
      nil -> nil
      _ -> show_profile(id)
    end
  end

  def get_profile_by(attrs) do
    @repo.get_by(Profile, attrs)
  end

  def update_profile(%Salt.Profile{} = profile, updates) do
    IO.puts("UPDATEING PROFILE SALT")

    profile
    |> Salt.Profile.changeset(updates)
    |> @repo.update()
    |> IO.inspect()
  end

  def edit_profile(id) do
    get_profile(id)
    |> Profile.changeset()
  end

  def delete_profile(%Salt.Profile{} = profile), do: @repo.delete(profile)

  #################################################################
  # Student functions  - for students on Phoenix side of umbrella #
  # alias for Student.changeset - Salt.Student.changeset       #
  #################################################################

  #  Student.changeset(%Student{})   # Return a blank changeset
  def new_student, do: Student.changeset(%Student{})

  def insert_student(params) do
    # Salt.Student
    # should return a change set with changes containing data

    %Student{}
    |> Student.changeset(params)
    |> @repo.insert()
  end

  # Fetches a single struct from the data store where
  # the primary key matches the given student id
  # returns a changeset struct
  def get_student(id) do
    @repo.get!(Student, id)
  end

  # Given user id return all students belonging to the user
  # seems crude  - is there a better way?
  def get_student_id(userid) do
    query = from(Student, where: [user_id: ^userid], select: [:id])
    Repo.all(query) |> Enum.at(0) |> Map.get(:id)
  end

  def get_student_profile(id) do
    # returns a struct
    get_profile(id)
  end

  # input student id - return a changeset
  def show_student(id) do
    # %Salt.Student{
    #   __meta__: #Ecto.Schema.Metadata<:loaded, "students">,
    #   birthday: "",
    #   firstname: "Jude",
    #   grade: "5",
    #   id: 30,
    #   inserted_at: ~N[2022-06-09 00:00:00],
    #   registrations: #Ecto.Association.NotLoaded<association :registrations is not loaded>,
    #   updated_at: ~N[2022-06-09 00:00:00],
    #   user: #Ecto.Association.NotLoaded<association :user is not loaded>,
    #   user_id: 67
    # }
    # returns a changeset

    get_student(id)
    # pipe to Salt.Student.changeset() - if nothe chaged we get an emppty changeset
    # Ecto.Changeset<action: nil, changes: %{}, errors: [], data: #Salt.Student<>,
    |> Student.changeset()

    # valid?: true>
  end

  # show all students for one user - getting user profile instead ERROR
  def show_students(id) do
    Salt.get_student_profile(id)

    Salt.get_user(id)
    # as a struct containing a list of structs - students:
    |> @repo.preload(:students)
    # a list of changesets
    |> show_students_changesets()
  end

  def make_changeset(map) do
    # ("student changeset")
    Student.changeset(map)
  end

  def show_students_changesets(maplist) do
    student_list = maplist.students
    # for student <- student_list do
    Enum.map(student_list, &make_changeset/1)
  end

  def get_student_by(attrs) do
    @repo.get_by(Student, attrs)
  end

  def update_student(%Salt.Student{} = student, params) do
    # student is a changeset
    # params are a map of key, value pairs using string keys
    # convert the keys to atoms
    updates = Salt.key_to_atom(params)

    student
    |> Student.changeset(updates)
    |> @repo.update()
  end

  def edit_student(id) do
    # IO.puts("get student")

    get_student(id)
    |> Student.changeset()
  end

  def delete_student(%Salt.Student{} = student), do: @repo.delete(student)

  # Given user id return a list of student ids
  # seems crude  - is there a better way?
  def get_student_ids(userid) do
    query = from(Student, where: [user_id: ^userid], select: [:id])
    Repo.all(query) |> Enum.map(fn x -> x.id end)
  end

  # Given user id return a list of student maps
  # Get all students for one user - alternate method
  def get_students(id) do
    query =
      from(Student,
        where: [user_id: ^id],
        select: [:firstname, :grade, :birthday, :id, :updated_at, :user_id]
      )

    # brings back list of structs
    Repo.all(query)
  end

  # for one user - get one student by first name
  def get_student_id(userid, firstname) do
    query =
      from(Student,
        where: [user_id: ^userid],
        where: [firstname: ^firstname],
        select: [:id, :user_id]
      )

    # , preload [:registrations]  #brings back list of structs
    Repo.all(query)
  end

  # stuff = Student.changeset(%Student{}, studentparams)
  # check if there are students
  def check_students(id) do
    # user =
    Salt.get_user(id)
    # If there exists a student - nilstudent will be a list of student structs
    # nilstudents = Repo.preload(user,:students).students
    |> Repo.preload([:profiles, :students])

    # case nilstudents.profiles.lastname do
    #  nil -> nil #check_nil()
    #  _ -> #show_students(id)
    # end
  end

  ######################################################################
  # registration functions  - for students on Phoenix side of umbrella #
  # alias for Registration.changeset - Salt.Registration.changeset  #
  ######################################################################

  #  Registration.changeset(%Registration{})   # Return a blank changeset an empty map
  def blank_new_registration() do
    %Registration{}
    # should return a change set with changes containing data
    # studentID needs to be in a
    |> Registration.changeset()

    # Registration.changeset(%Registration{})
  end

  def create_registration(params) do
    %Registration{}
    # should return a change set with changes containing data
    |> Registration.changeset(params)
    |> @repo.insert()

    # |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])
  end

  # Fetches the student id associated with registration id
  def get_student_id_from_registration(id) do
    @repo.get!(Registration, id).student_id
  end

  # Fetches a single map from the data table where
  # the primary key matches the given id
  # id is the registration id
  def get_registration(id) do
    @repo.get!(Registration, id)
  end

  def get_period(class_id) do
    @repo.get!(Period, class_id)
  end

  def get_section(section_id) do
    @repo.get!(Section, section_id)
    |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])
  end

  def show_registration(id) do
    # looks like a changeset
    get_registration(id)
    |> Registration.changeset()
  end

  # Given semester return a list of registrations classes
  # Get all students for one user - alternate method
  def get_registration_semester(_semester) do
    query = from(Registration)
    # brings back list of structs
    Repo.all(query)
    # |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])
    |> @repo.preload(
      class: :classtitle,
      class: :period,
      class: :section,
      class: :teacher,
      class: :helper1,
      class: :helper2
    )
  end

  #####################################
  # Get all registrations for student #
  #####################################
  # id is student primary key id
  def get_student_registrations(id) do
    query = from(Registration, where: [student_id: ^id])

    # |> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher, class: :helper1, class: :helper2])
    @repo.all(query)
  end

  ####################################
  # Get one registration for student #
  # Perhaps the first one            #
  ####################################
  # id is student primary key id
  def get_registration_by_one(student_id) do
    # IO.puts("Get reg by one")

    Registration
    |> where([r], r.student_id == ^student_id)
    |> limit(1)
    |> @repo.all

    # |> List.first(1)
  end

  # alternate syntax
  # def get_student_registrations(id)   # id is studeht primary key id
  #  query = from(Registrations, where: [student_id: id]
  #  Repo.all(query)
  # end

  def get_registration_by_three(student_id, class_id, semester) do
    Registration
    |> where(
      [r],
      r.student_id == ^student_id and r.class_id == ^class_id and r.semester == ^semester
    )
    |> @repo.all
  end

  ################################################################################################
  # Why do we need select?                                                                       #
  # 08:55:21.281 [debug] QUERY OK source="registrations" db=5.9ms queue=0.4ms idle=1455.0ms  RED #
  # DELETE FROM "registrations" AS r0 WHERE (r0."id" = 151) RETURNING r0."student_id" []     RED #
  # {1, [30]} - returns student_id in a list enclosed in a tuple  list of structs                #
  ################################################################################################

  def delete_registration(id) do
    registration = get_registration(id)
    @repo.delete(registration)
  end

  def get_fee(semester, fallfee, springfee) do
    cond do
      ^semester = 1 -> fallfee
      ^semester = 2 -> springfee
    end

    "fee unknown"
  end

  ###############################################################
  # id is registration id - return class for that registration. #
  ###############################################################
  def get_class_from_registration(id) do
    get_registration(id).class_id
    |> Salt.get_class()
    |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])
  end

  ###############################################################
  # id is class id - return class for that class id.               #
  ###############################################################
  def get_class_from_classid(classid) do
    Salt.get_class(classid)
    |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])
  end

  ##############################################################
  # Class functions  - for classes on Phoenix side of umbrella #
  ##############################################################

  #  Class.changeset(%Class{})   # Return a blank changeset
  def new_class, do: Class.changeset(%Class{})

  def insert_class(params) do
    # Salt.Student
    %Class{}
    # should return a change set with changes containing data
    |> Class.changeset(params)
    |> @repo.insert()
  end

  # Fetches a single struct from the data store where
  # the primary key matches the given id
  def get_class(id) do
    @repo.get!(Class, id)
  end

  # given the classtitle id get the description
  def get_class_title(title_id) do
    @repo.get!(Classtitle, title_id)
  end

  # |> @repo.preload(classtitle: [class: [registration: :student]])

  def get_teacher_name(id) do
    # returns a struct
    prof = get_profile(id)
    prof.firstname <> " " <> prof.lastname
    # Enum.join([prof.firstname, prof.lastname], " ")
  end

  def show_class(id) do
    # query =
    from(Class, order_by: [:description])
    # looks like a changeset
    get_class(id)
    |> Class.changeset()
  end

  def get_class_by(attrs) do
    @repo.get_by(Class, attrs)
  end

  def update_class(%Salt.Class{} = class, updates) do
    class
    |> Salt.Class.changeset(updates)
    |> @repo.update()
  end

  def edit_class(id) do
    get_class(id)
    |> Class.changeset()
  end

  def delete_class(%Salt.Class{} = class), do: @repo.delete(class)

  def show_classes(id) do
    Salt.get_user(id)
    |> @repo.preload(:classes)
  end

  # for x <- list, do: x.description
  def get_classtitles() do
    # newlist = []
    query = from(Classtitle, order_by: [:description], select: [:id, :description])
    Repo.all(query)
    # query = from(Classtitle, select: [:description])
    # alist = Repo.all(query)
    # for x <- alist do
    #  newlist ++  [Integer.to_string(x.id), x.description]
    # end
  end

  # returns a nested map - including period, section, class title - profiles for teachers
  def list_class_data(id, classid, semester) do
    # nested map
    regdata = Salt.get_class_from_classid(classid)
    classtitle = regdata.classtitle.description
    fallfee = regdata.fallfee
    springfee = regdata.springfee
    fee = Salt.get_fee(semester, fallfee, springfee)
    section = regdata.section.description
    period = regdata.period.time
    teachername = Salt.get_teacher_name(regdata.teacher.id)
    helper1name = Salt.get_teacher_name(regdata.helper1.id)
    helper2name = Salt.get_teacher_name(regdata.helper2.id)

    # list =
    [
      id,
      classid,
      classtitle,
      section,
      period,
      fee,
      semester,
      teachername,
      helper1name,
      helper2name
    ]
  end

  #########################################################
  # id is classtitle id - return classes with that title. #
  #########################################################

  def get_class_from_title(title_id) do
    query = from(Class, where: [classtitle_id: ^title_id])

    Repo.all(query)
    |> @repo.preload([:classtitle, :period, :section, :teacher, :helper1, :helper2])

    # Repo.all(query) |> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher, class: :helper1, class: :helper2])
  end

  def testlist([]), do: []

  def testlist([[title, section, period, fee, semester, name, helper1, helper2] | tail]) do
    [[title, section, period, fee, semester, name, helper1, helper2] | testlist(tail)]

    # IO.puts("REcursion")
  end

  # [ [title, section, period, fee, semester, name, helper1, helper2] tail] | testlist(tail) ]
  # end
  def testlist([_ | tail]), do: testlist(tail)
end
