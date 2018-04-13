defmodule Bepaid do
  defmodule Error do
    @moduledoc """
    Defines an exception for Bepaid errors.
    """
    defexception [:message]
  end

  def start_link do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: Bepaid.Supervisor]
    {:ok, _pid} =  Supervisor.start_link(children, opts)
  end
end
