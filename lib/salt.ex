defmodule Salt do
  alias Salt.{
    Repo,
    User,
    Password,
    Profile,
    Period,
    Section,
    Student,
    Class,
    Classtitle,
    Registration
  }

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

  ##########################################
  # get data from schema struct            #
  # return the data as an atom based map   #
  ##########################################
  def extract_from_schema(string_map) do
    schema_map =
      string_map |> Salt.key_to_atom() |> Map.delete(:_csrf_token) |> Map.delete(:_method)

    idx = schema_map |> Map.keys() |> List.first()
    Map.get(schema_map, idx) |> Salt.key_to_atom()
  end

  ################################################################
  # User functions  - for users on Phoenix side of umbrella      #
  ################################################################

  def get_user(id) do
    @repo.get(User, id)
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

  def get_roles(userid) do
    query = from(User, where: [id: ^userid], select: [:roles])
    Repo.all(query)
    |> Enum.at(0)
    |> Map.get(:roles)
  end

  def delete_user(userid) do
    user = Repo.get!(User, userid)
    case Repo.delete user do
      nil -> nil
      _ -> @repo.delete(user)
    end
  end

  ###############################################################################
  # Class table has a teacher column as an array of user ids - type string      #
  # Submit an array to this function to return an array of "firstname lastname" #
  ###############################################################################
  def get_teacher_list(tlist) do
    case tlist do
      nil -> ["", "", ""]
      _ -> Enum.map(tlist, fn userid -> Salt.get_user_name(userid) end)
    end
  end

  # given user id - return firstname + space + lastname
  def get_user_name(id) do
    case id do
      nil -> nil
      ""  -> nil
      _ ->
        fname = get_user_firstname(id)
        lname = get_user_lastname(id)
        fname <> " " <> lname
      end
  end

  # given user id - return firstname
  def get_user_firstname(id) do
    prid = Salt.get_user(id)
    nilprofile = Repo.preload(prid, :profiles).profiles

    case nilprofile do
      # check_nil()
      nil -> nil
      _ -> nilprofile.firstname
    end
  end

  # given user id - return lastname
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
    # create changeset with included parameters
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
  # or nil if it does not exist
  def get_profile_nil(id) do
    query = from(Profile, where: [user_id: ^id])
    @repo.one(query)
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

  # check if there is a profile - for user ID
  def check_profile(id) do
    # prid = Salt.get_user(id)
    # If there exists a profile - nilprofile will be a profile struct
    # If there is no profile    - nilprofile will be nil
    nilprofile = get_profile_nil(id)

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
    profile
    |> Salt.Profile.changeset(updates)
    |> @repo.update()
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
    # schema
    get_student(id)

    # pipe to Salt.Student.changeset() - if nothing changed we get an empty changeset
    |> Student.changeset()

    # Ecto.Changeset<action: nil, changes: %{}, errors: [], data: #Salt.Student<>,
    # returns a changeset
    # valid?: true>
  end

  # show all students for one user - getting user profile instead ERROR
  def show_students(id) do
    # IO.puts("USER ID") #67
    # Salt.get_student_profile(id)
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
    # params are a map of key, value pairs using STRING KEYS
    # convert the KEYS to ATOMS
    updates = Salt.key_to_atom(params)

    student
    |> Student.changeset(updates)
    |> @repo.update()
  end

  def edit_student(id) do
    get_student(id)
    |> Student.changeset()
  end

  def get_student_struct(id) do
    Repo.get(Student, id)
  end

  def delete_student(id) do
    student = get_student_struct(id)

    case student do
      nil -> nil
      _ -> @repo.delete(student)
    end
  end

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
  # insert functions  - for students on Phoenix side of umbrella #
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

  def insert_registration(params) do
    # Salt.Registration
    # should return a change set with changes containing data

    %Registration{}
    |> Registration.changeset(params)
    |> @repo.insert()
  end

  def create_registration(params) do
    %Registration{}

    # should return a change set with changes containing data
    |> Registration.changeset(params)
    |> @repo.insert()

    # |> @repo.preload([:classtitle, :period, :section, :teacher])
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
    # |> @repo.preload([:classtitle, :period, :section, :teacher])
    |> @repo.preload(
      class: :classtitle,
      class: :period,
      class: :section,
      class: :teacher
    )
  end

  #####################################
  # Get all registrations for student #
  #####################################
  # id is student primary key id
  def get_student_registrations(id) do
    query = from(Registration, where: [student_id: ^id])

    # |> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher])
    @repo.all(query)
  end

  ##################################################
  # Get a count of all registrations for a student #
  ##################################################
  def count_student_registrations(student_id) do
    query =
      from(r in "registrations",
        where: r.student_id == ^student_id,
        select: count(r.student_id)
      )

    Repo.one(query)
  end

  ####################################
  # Get one registration for student #
  # Perhaps the first one            #
  ####################################
  # id is student primary key id
  def get_registration_by_one(student_id) do
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

  def get_fee(fee) do
    case fee do
      "" -> "unknown fee"
      nil -> "unknown fee"
      _-> "$"<>to_string(fee)
    end
  end

  ###############################################################
  # id is registration id - return class for that registration. #
  ###############################################################
  def get_class_from_registration(id) do
    get_registration(id).class_id
    |> Salt.get_class()
    |> @repo.preload([:classtitle, :period, :section, :teacher])
  end

  ###############################################################
  # id is class id - return class for that class id.               #
  ###############################################################
  def get_class_from_classid(classid) do
    Salt.get_class(classid)
    |> @repo.preload([:classtitle, :period, :section])
  end

  #########################################################
  # id is classtitle id - return classes with that title. #
  #########################################################

  def get_classes_from_title(title_id) do
    from(Class, where: [classtitle_id: ^title_id])
    |> @repo.all()
    |> @repo.preload(:section)
    |> @repo.preload(:period)
    |> @repo.preload(:classtitle)
  end

  ##############################################################
  # Class functions  - for classes on Phoenix side of umbrella #
  ##############################################################

  #  Class.changeset(%Class{})   # Return a blank changeset
  def new_class() do
    Class.changeset(%Class{})
  end

  def get_classes() do
    query = from(Classes)
    @repo.all(query)
  end

  def insert_class(params) do
    # Salt.Student
    %Class{}
    # should return a change set with changes containing data
    |> Class.changeset(params)
    |> @repo.insert()
  end

  # Fetches a single struct from the class table where
  # the primary key matches the given class id
  def get_class(id) do
    @repo.get_by(Class, id: id)
  end

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

  # attrs should be a map - ex: attrs = %{id: 61}
  def get_class_by(attrs) do
    @repo.get_by(Class, attrs)
  end

  def get_userid_from_name(nil), do: nil
  def get_userid_from_name(""),  do: nil

  def get_userid_from_name(name) do

    namelist = String.split(name, " ")
    fname = Enum.at(namelist,0)
    lname = Enum.at(namelist,1)
    query = from(Profile, where: [firstname: ^fname, lastname: ^lname], select: [:user_id])
    result = Repo.all(query)
    Enum.at(result,0).user_id
  end

  def build_teacher_list(t1, t2, t3) do
    # delete nils - i.e. less than 3 teachers
    # the list must have 3 items - some or all may be nils
    # to_string(nil) = ""
    list = []
    list = [to_string(t1) | list]
    list = [to_string(t2) | list]
    list = [to_string(t3) | list]
    list = List.delete(list,"")
    list = List.delete(list,"")
    list = List.delete(list,"")
  end

  def transform_class_updates(_class, update_map) do
    map = update_map
    |> IO.inspect()
    p = Repo.get_by(Salt.Period, time: map.period_id).id
    s = Repo.get_by(Salt.Section, description: map.section_id).id
    c = Repo.get_by(Salt.Classtitle, description: map.classtitle_id).id

    fee = fee_to_integer(map.fee)
    map = Map.merge(map, %{classtitle_id: c, period_id: p, section_id: s, fee: fee})

    t1 = get_userid_from_name(map.teacher1_id)
    t2 = get_userid_from_name(map.teacher2_id)
    t3 = get_userid_from_name(map.teacher3_id)
    teacher = build_teacher_list(t1,t2,t3)
    map = Map.delete(map, :teacher1_id)
    map = Map.delete(map, :teacher2_id)
    map = Map.delete(map, :teacher3_id)
    map = Map.put_new(map,:teacher,teacher)
  end

  def update_class(%Salt.Class{} = class, updates) do
    IO.inspect(class)
    IO.inspect(updates)
    IO.puts("SALT UPDATE CLASS")
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
    query = from(Classtitle, order_by: [:description], select: [:id, :description])
    @repo.all(query)
  end

  # returns a nested map - including period, section, class title - profiles for teachers
  def list_class_data(id, classid, semester) do
    # nested map
    classdata = Salt.get_class_from_classid(classid)
    classtitle = classdata.classtitle.description
    fee = classdata.fee
    fee = Salt.get_fee(fee)
    section = classdata.section.description
    period = classdata.period.time
    teacher = Salt.get_teacher_list(classdata.teacher)
    teacher1 = Enum.at(teacher,0)
    teacher2 = Enum.at(teacher,1)
    teacher3 = Enum.at(teacher,2)
    # list =
    [
      id,
      classid,
      classtitle,
      section,
      period,
      fee,
      semester,
      #teacher,
      teacher1,
      teacher2,
      teacher3
    ]
  end

  #########################################################
  # id is classtitle id - return classes with that title. #
  #########################################################

  def testlist([]), do: []

  def testlist([[title, section, period, fee, semester, name, teacher] | tail]) do
    [[title, section, period, fee, semester, name, teacher] | testlist(tail)]
  end

  # [ [title, section, period, fee, semester, name, teacher] tail] | testlist(tail) ]
  # end
  def testlist([_ | tail]), do: testlist(tail)

  #################################################################
  # classtitles functions  - for classtitles on Phoenix side of   #
  #################################################################
  def new_classtitle do
    # Return a blank changeset
    Classtitle.changeset(%Classtitle{})
  end

  ##########################################################################
  # Alternately Salt.Classtitle |> struct() in place of %Classtitle{}      #
  # %Classtitle{} is a struct - Kernel.struct/2 changes a map to a struct  #
  # changeset/2 - arg 1 is a struct, arg2 is a map of attributes           #
  # Attributes - need to be verified and updated - default is an empty map #
  ##########################################################################
  def insert_classtitle(params) do
    %Classtitle{}
    |> Classtitle.changeset(params)
    |> @repo.insert()
  end

  ##################################
  # returns a schema struct or nil #
  ##################################

  #def get_classtitles() do
  #  query = from(Classtitles)
  #  @repo.all(query)
  #end

  def get_class_teacher_list(role) do
    query = from(u in User, where: ^role in u.roles, select: [u.id, u.username])
    @repo.all(query)
  end

  def get_class_period_list() do
    query = from(p in Period, order_by: [p.time], select: [p.id, p.time])
    @repo.all(query)
  end

  def get_class_section_list() do
    query = from(s in Section, order_by: [s.description], select: [s.id, s.description])
    @repo.all(query)
  end

  def get_classtitle_list() do
    # newlist = []
    query =
      from(c in Classtitle, order_by: [c.description], select: [c.id, c.description, c.syllabus])

    @repo.all(query)
    |> clean_nils()
  end

  # Given a class id - return the corresponding title changeset
  def get_classtitle_from_class(id) do
    @repo.get!(Class, id).classtitle_id
    |> Salt.show_classtitle()
  end

  # Given a classtitle id - return the title record
  def get_classtitle(id) do
    @repo.get(Classtitle, id)
  end

  # Given classtitle id return a classtitle changeset
  def show_classtitle(id) do
    # convert to changeset
    title = get_classtitle(id)
    case title do
       nil -> nil
      _ -> Classtitle.changeset(title)
    end
  end

  # check if there is a classtitle - for classtitle ID
  def check_classtitle(id) do
    prid = Salt.get_classtitle(id)
    # If there exists a profile - nilprofile will be a classtitle struct
    # If there is no profile     - nilprofile will be nil
    nilclasstitle = case prid do
      nil -> nil
      _ -> show_classtitle(id)
    end
  end

  def get_classtitle_by(attrs) do
    @repo.get_by(Classtitle, attrs)
  end

  def update_classtitle(%Salt.Classtitle{} = classtitle, params) do
    updates = Salt.key_to_atom(params)
    classtitle
    |> Salt.Classtitle.changeset(params)
    |> @repo.update()
  end

  def edit_classtitle(id) do
    get_classtitle(id)
    |> Classtitle.changeset()
  end

  def delete_classtitle(id) do
    registration = get_classtitle(id)
    @repo.delete(registration)
  end

  # def delete_classtitle(%Salt.Classtitle{} = classtitle), do: @repo.delete(classtitle)

  def titlechangeset_to_list(amap) do
    [Map.fetch!(amap, :id), Map.fetch!(amap, :description), Map.fetch!(amap, :syllabus)]
  end

  #####################################################################
  # class dropdown list functions  - for  making javascript dropdowns #
  #####################################################################
  def get_class_sections() do
    query = from(Sections)
    @repo.all(query)
  end

  def get_class_periods() do
    query = from(Periods)
    @repo.all(query)
  end

  #######################################
  # miscellaneous queries and functions #
  #######################################
  def get_class_titles() do
    query =
      from(c in Classtitle,
        order_by: [asc: c.description],
        select: c.description
      )

    Repo.all(query)
  end

  def get_class_title(id) do
    from(Classtitle, where: [id: ^id], select: [:id, :description])
    |> Repo.all()
  end

  # id is class primary key id
  def get_class_by_title(titleid) do
    query = from(Class, where: [classtitle_id: ^titleid])
    # |> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher])
    @repo.all(query)
  end

  #############################################################################
  # returns a nested list - including period, section, class title - teachers #
  # teachers is a nested list in the list                                     #
  #############################################################################
  def list_oneclass_data(classid) do
    # nested map
    IO.puts("ONE CLASS DATA")
    classdata = Salt.get_class_from_classid(classid)
    classtitle = classdata.classtitle.description
    fee = classdata.fee
    semester = classdata.semester
    section  = classdata.section.description
    period   = classdata.period.time
    teachername = Salt.get_teacher_list(classdata.teacher)

    [
      classid:     classid,
      classtitle:  classtitle,
      section:     section,
      period:      period,
      fee:         fee,
      semester:    semester,
      teachername: teachername
    ]
  end

  ######################################################
  # Class teacher column is a list of teacher user ids #
  # This function returns a list of teacher names      #
  # Which are strings "firstname lastname"             nil#
  ######################################################
  def get_teachers_by_classid(id) do
    class = Repo.get(Class, id)

    class.teacher
    |> List.flatten()
    |> Enum.map(fn i -> Salt.get_teacher_name(i) end)
  end

  # id of a classtitle - return a list of classes
  def get_classes_by_id(id) do
    query =
      from(t in Classtitle,
        where: [id: ^id],
        join: c in Class,
        on: t.id == c.classtitle_id,
        select: {c.id, c.classtitle_id, c.fee, c.semester, c.teacher, c.period_id, c.section_id}
      )
    # preload: [:classtitle, :section, :period, :teacher]
    Repo.all(query) #|> List.flatten() |> Repo.preload([:section, :period, :classtitle])
    # Enum.map(q, fn x -> Salt.list_oneclass_data(hd(x), 1) end)
  end

  def build_class_map(map) do
    result = %{}
    classid    = elem(map,0)
    titleid    = elem(map,1)
    fee        = fee_to_integer(elem(map,2))
    semester   = elem(map,3)
    teacher    = elem(map,4)
    teacher    = case teacher do
                 nil -> []
                 _ -> teacher
    end
    period     = get_period_time(elem(map,5))
    section    = get_section_description(elem(map,6))
    classtitle = get_classtitle_description(titleid)

    teacher1 = Salt.get_user_name(Enum.at(teacher,0))
    teacher2 = Salt.get_user_name(Enum.at(teacher,1))
    teacher3 = Salt.get_user_name(Enum.at(teacher,2))
    result   = Map.put_new(result, :id , classid)
    result   = Map.put_new(result, :classtitle, classtitle)
    result   = Map.put_new(result, :fee, fee)
    result   = Map.put_new(result, :semester, semester)
    result   = Map.put_new(result, :period, period)
    result   = Map.put_new(result, :section, section)
    result   = Map.put_new(result, :teacher1, teacher1)
    result   = Map.put_new(result, :teacher2, teacher2)
    result   = Map.put_new(result, :teacher3, teacher3)
    #result   = Map.put_new(result, :teacher, teacher)
  end

  #####################################
  # HA HA ain't this short and sweet  #
  #####################################
  def build_class_list(titleid) do
    list = Salt.get_classes_by_id(titleid)
    Enum.map(list, fn x-> Salt.build_class_map(x) end)
  end

  ######################
  # utility functions  #
  ######################

  # given a classtitle id return the description as a string
  def get_classtitle_description(tid) do
    @repo.get(Classtitle, tid).description
  end

  # given a section id return the description as a string
  def get_section_description(sid) do
    @repo.get(Section, sid).description
  end

  # given a period id return the time as a string
  def get_period_time(pid) do
    @repo.get(Period, pid).time
  end

  def get_teachername(tlist, num) do
    id = Enum.at(tlist,num)
    Salt.get_user_name(id)
  end
  ###################################################
  # works for num = quoted integer, quoted float    #
  # unquoted integer or unquoted float              #
  # string will return :error                       #
  # Otherwise a quoted float or integer is returned #
  ###################################################

  def is_number(num) do
    case Integer.parse(to_string(num)) do
      :error -> :error
    _-> num
    end
  end

  def choose_from_two(who, stringTrue, stringFalse) do
    result =
      cond do
        who == true ->
          stringTrue

        who == false ->
          stringFalse
      end
  end


  def is_teacher(roles) do
    Enum.member?(roles, "administrator") or  Enum.member?(roles, "teacher")
  end

  def is_administrator(roles) do
    Enum.member?(roles, "administrator")
  end

  defp clean_nils(list) do
    for n <- list do
      Enum.map(n, fn x -> if x == nil, do: " ", else: x end)
    end
  end

  def fee_to_integer(fee) do
    isbinary = is_binary(fee)
    isnil    = fee == nil

    dot = case isbinary do
      true -> String.contains?(fee, ".")
      _ -> false
    end

    digits = case isbinary do
      true -> String.contains?(fee, ["0", "1", "2","3", "4", "5", "6", "7", "8", "9"])
      _ -> false
    end

    cond do
      isbinary  && digits  &&  dot  -> round(String.to_float(fee))
      isbinary  && digits  && !dot -> String.to_integer(fee)
      isbinary  && !digits && !dot -> nil
      isnil                        -> nil
      !nil && !isbinary && !digits && !dot -> round(fee)
    end
  end
  ###############################################
  # convert a list of maps into a tuple of maps #
  # count is the length of the list minus 1     #
  ###############################################
  def list_to_tuple(list, tuple, count \\ 0)
  def list_to_tuple(list, tuple, count) when count < 0, do: tuple
  def list_to_tuple(list, tuple, count) do
    new_count = count - 1
    list_to_tuple(list, Tuple.append(tuple, Enum.at(list, count)), new_count)
  end

end
