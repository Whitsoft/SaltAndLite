defmodule SaltWeb.HelloWorld do
  def hello(%{name: username}) do
    "Hello #{username}"
  end
end
