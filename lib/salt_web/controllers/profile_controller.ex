defmodule SaltWeb.ProfileController do
  use SaltWeb, :controller

  alias Salt.Profile

  plug(:require_logged_in_user)

  # @profile_map = %{title: title, lastname: lastname, firstname: firstname, spousename: spousename, streetaddress: streetaddress, city: city,
  # state: state, zipcode: zipcode, phoneone: phoneone, phonetwo: phonetwo}

  #########
  # INDEX #
  #########
  def index(conn, _params) do
    profile = Salt.new_profile()
    render(conn, "index.html", profile: profile)
  end

  #########
  # SHOW  #
  #########
  def show(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id

    # return nil or return a profile changeset
    profile = Salt.check_profile(userid)
    submitter = nil

    case profile do
      nil ->
        render(conn, "new.html",
          profile: profile,
          current_user: current_user,
          submitter: submitter
        )

      _ ->
        render(conn, "show.html",
          profile: profile,
          submitter: submitter,
          userid: userid,
          layout: {SaltWeb.LayoutView, "showprofile.html"}
        )
    end
  end

  ######################################
  # profile is a changeset             #
  # profile.data is a schema struct    #
  # in the new case all fields are nil #
  ######################################

  #########
  # NEW   #
  #########
  def new(conn, _params) do
    # an empty changeset
    profile = Salt.new_profile()

    current_user = Map.get(conn.assigns, :current_user)

    userid = current_user.id

    username = current_user.username

    submitter = 1
    # action = Routes.profile_path(@conn, :create)

    conn
    |> assign(:profile, profile)
    |> assign(:current_user, current_user)
    |> assign(:submitter, submitter)
    |> assign(:layout, {SaltWeb.LayoutView, "editstudent.html"})
    |> render("new.html")
  end

  ##########
  # CREATE #
  ##########
  def create(conn, %{"profile" => profile_params}) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id

    # insert user :id into profile :user_id
    newparams = Map.put(profile_params, "user_id", userid)

    profile = Profile.changeset(%Profile{}, newparams)

    case Salt.insert_profile(newparams) do
      {:ok, profile} -> redirect(conn, to: Routes.profile_path(conn, :show, profile))
      {:error, profile} -> render(conn, "new.html", Profile: profile)
    end
  end

  ############################################
  # EDIT                                     #
  # params instead of %{"id" => id}) because #
  # in router params declared as singleton   #
  ############################################
  def edit(conn, _params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    profile = Salt.show_profile(userid)
    lastname = Salt.get_user_lastname(userid)
    firstname = Salt.get_user_firstname(userid)
    submitter = 1
    action = Routes.profile_path(conn, :update)

    conn
    |> assign(:profile, profile)
    |> assign(:firstname, firstname)
    |> assign(:lastname, lastname)
    |> assign(:submitter, submitter)
    # |> assign(:layout, {SaltWeb.LayoutView, "editprofile.html"})
     |> assign(:action, action)
    |> render("edit.html", layout: {SaltWeb.LayoutView, "editprofile.html"})

    # |> render("edit.html")
  end

  ##########
  # UPDATE #
  ##########
  def update(conn, profile_params) do
    current_user = Map.get(conn.assigns, :current_user)
    userid = current_user.id
    profile = Salt.get_profile(userid)

    updates =
      Salt.extract_from_schema(profile_params)
      |> IO.inspect()

    case Salt.update_profile(profile, updates) do
      {:ok, profile} ->
        redirect(conn, to: Routes.profile_path(conn, :show))
        # {:error, profile} -> render(conn, "edit.html", profile: profile)
    end
  end

  # Pattern match to determine that there is no current user
  defp require_logged_in_user(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to create a profile.")
    |> redirect(to: Routes.profile_path(conn, :index))
    |> halt()
  end

  # Pass on the conn because there is a current user
  defp require_logged_in_user(conn, _opts), do: conn
end
