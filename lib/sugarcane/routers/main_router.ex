defmodule Sugarcane.Routers.Main do
  use Plug.Router
  
  plug Sugarcane.MetricsExporter
  plug :match
  plug :dispatch
  
  
  get "/" do
    send_resp(conn, 200, "hotline")
  end
end