defmodule Sugarcane.Routers.Main do
  use Plug.Router
  alias Sugarcane.Templates.Helper
  
  plug Sugarcane.MetricsExporter
  plug :match
  plug :dispatch
  
  
  get "/" do
    Helper.render(conn, "index")
  end
end