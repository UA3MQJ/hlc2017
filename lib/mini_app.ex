defmodule MiniApp do
    use Application
  require Logger

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Logger.debug ">>>>> Start server"

    # запускаем только cowboy'ский веб сервер, чтобы проверять работоспособность
    port = Application.get_env(:mini_app, :cowboy_port, 80)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, MiniApp.Router, [], port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
