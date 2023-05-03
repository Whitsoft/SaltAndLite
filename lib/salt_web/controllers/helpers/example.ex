defmodule SaltWeb.Example do
  defmacro __using__(_opts) do
    quote do
      def injected_method do
        "example return value"
      end
    end
  end
end
