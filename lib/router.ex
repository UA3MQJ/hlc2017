defmodule MiniApp.Router do

  use Plug.Router
  use Plug.Debugger

  plug Plug.Parsers, parsers: [:erlencoded, :multipart]
  plug :match
  plug :dispatch

  require Logger

  get "/" do
    send_resp(conn, 200, "Im work (updated)")
  end

  get "/:entity/:id" do
    # Logger.debug ">>> get entity=#{inspect entity} id=#{inspect id}"
    case MiniApp.KVS.get(entity, id) do
      nil ->
        send_resp(conn, 404, "")
      value ->
        body = Poison.encode!(value)
        # send_resp(conn, 200, body)
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json; charset=UTF-8")
        |> Plug.Conn.send_resp(200, body)
    end
  end

end
