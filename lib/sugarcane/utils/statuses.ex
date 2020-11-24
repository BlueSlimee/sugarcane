defmodule Sugarcane.Utils.Status do
  use GenServer
  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end
  
  def init(init_arg) do
    Process.send_after(self(), :update, 10000)
    
    {:ok, init_arg}
  end
  
  def handle_info(:update, state) do
    {type, name} = Enum.random(statuses())
    
    Nostrum.Api.update_status(
      :dnd,
      name,
      type
    )
    
    Process.send_after(self(), :update, 15000)
    {:noreply, state}
  end
  
  defp statuses do
    [
    {0, "Animal Crossing"},
    {0, "Call of Duty"},
    {0, "PUBG"},
    {2, "positions"},
    {2, "Dead to Me"},
    {2, "Just a Stranger"},
    {2, "Loner"},
    {2, "Dreams"},
    {2, "Time (is)"},
    {2, "Deep Inside"},
    {2, "@Sugarcane"},
    {2, "Pierrot Lunaire"},
    {2, "Gypsy Woman (She's Homeless)"},
    {2, "She Can't Love You Like I Do"},
    {2, "Ain't No Mountain High Enough"},
    {3, "Station 19"},
    {3, "Grey's Anatomy"},
    {3, "Brooklyn 99"},
    {3, "Jane the Virgin"},
    {3, "Private Practice"},
    {5, "a PUBG tournament"},
    {5, "a COD tournament"},
    {5, "my backyard"},
    {5, "an osu! tournament"},
    {5, "something"},
    {5, "NYC"}
    ]
  end
end