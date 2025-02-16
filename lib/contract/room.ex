defmodule Contract.Room do
  import Contract.Entity.State
  alias Contract.Entity

  def reserve() do
    state = Entity.state()
  end

  def join(name, password) do
  end
end
