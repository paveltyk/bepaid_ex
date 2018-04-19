defmodule Bepaid do
  use Application

  defmodule Error do
    @moduledoc """
    Defines an exception for Bepaid errors.
    """
    defexception [:message]
  end


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: Bepaid.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
