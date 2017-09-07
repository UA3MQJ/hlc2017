defmodule MiniApp.KVS do
  use GenServer
  require Logger

  def start_link do
      :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def init(_) do
    Logger.debug ">>> KVS init"
    send(self(), :init)
    state = {%{},%{},%{}}
    {:ok, state}
  end

  def get(entity, id) do
    GenServer.call(__MODULE__, {:get, entity, id})
  end

  def handle_call({:get, entity, id}, _, {u_map, v_map, l_map} = state) do
    entity_map = case entity do
      "users" -> u_map
      "visits" -> v_map
      "locations" -> l_map
      _else -> nil
    end

    {int_id, _} = Integer.parse(id)

    response = cond do
      entity_map == nil -> nil
      true -> entity_map[int_id]
    end
    {:reply, response, state}
  end

  # delayed init
  def handle_info(:init, _state) do
    # users = read_file_async("users")
    # visits = read_file_async("visits")
    # locations = read_file_async("locations")

    {time_micro1, users} = :timer.tc(__MODULE__, :read_file_async, ["users"])
    time_ms1 = :erlang.round(time_micro1 / 1000)
    Logger.info "users length=#{inspect length(users)} #{time_ms1}ms"
    {time_micro2, visits} = :timer.tc(__MODULE__, :read_file_async, ["visits"])
    time_ms2 = :erlang.round(time_micro2 / 1000)
    Logger.info "visits length=#{inspect length(visits)} #{time_ms2}ms"
    {time_micro3, locations} = :timer.tc(__MODULE__, :read_file_async, ["locations"])
    time_ms3 = :erlang.round(time_micro3 / 1000)
    Logger.info "locations length=#{inspect length(locations)} #{time_ms3}ms"

    users_map = users
    |> Enum.map(fn(el) -> {el["id"], el} end)
    |> Enum.into(%{})

    visits_map = visits
    |> Enum.map(fn(el) -> {el["id"], el} end)
    |> Enum.into(%{})

    locations_map = locations
    |> Enum.map(fn(el) -> {el["id"], el} end)
    |> Enum.into(%{})

    {:noreply, {users_map, visits_map, locations_map}}
  end


  # asyc load json files
  def read_file_async(file) do
    priv_path =  Application.app_dir(:mini_app, "priv")

    Path.wildcard("#{priv_path}/data/#{file}_*.json") # read()
    |> Enum.map(fn(x) ->
                  Task.async(fn() ->
                               read_file(x, file)
                             end
                  )
                end)
    |> Enum.map(fn(x) ->
                  Task.await(x)
                end)
    |> List.flatten()
  end

  # read and json decode
  def read_file(file_name, obj_name) do
    map = File.read!(file_name)
    |> Poison.decode!()

    map[obj_name]
  end
end
