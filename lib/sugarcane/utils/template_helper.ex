defmodule Sugarcane.Templates.Helper do
  @path "lib/sugarcane/routers/templates/"
  def render(conn, template, assigns \\ []) do
    body = @path
      |> Kernel.<>(template)
      |> Kernel.<>(".html.eex")
      |> EEx.eval_file(assigns)

    Plug.Conn.send_resp(conn, 200, body)
  end
end