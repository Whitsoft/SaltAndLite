# a module plug
defmodule SaltWeb.Authenticator do
  import Plug.Conn

  def init(opts) do
    # 1'st requirement
    opts
  end

  # 2'nd requirement
  def call(conn, _opts) do
    configure_session(conn, drop: true)
    # get_session returns value for :user_id

    # user id from database such as 67 for Holly
    user =
      conn
      |> get_session(:user_id)
      |> case do
        nil -> nil
        id -> Salt.get_user(id)
      end

    # case
    # store either id or nil in current_user in conn
    assign(conn, :current_user, user)
  end

  # call
end
