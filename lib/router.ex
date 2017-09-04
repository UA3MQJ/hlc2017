defmodule MiniApp.Router do

  use Plug.Router
  use Plug.Debugger

  plug Plug.Parsers, parsers: [:erlencoded, :multipart]
  plug :match
  plug :dispatch

  require Logger

  get "/" do
    Logger.debug ">>>> get /"
    send_resp(conn, 200, "Im work (updated)")
  end

end
