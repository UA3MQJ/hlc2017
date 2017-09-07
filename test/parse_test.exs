defmodule MiniAppTest do
  use ExUnit.Case
  require Logger

  use Plug.Test
  alias MiniApp.Router

  @opts Router.init([])


  test "the truth" do

    # 1..100
    # |> Enum.map(fn args ->  
    # {time_micro1, result1} = :timer.tc(__MODULE__, :read_users, [])
    # time_ms1 = :erlang.round(time_micro1 / 1000)
    # Logger.debug "result1 length=#{inspect length(result1)} #{time_ms1}ms"
    
    # end)

    # 1..100
    # |> Enum.map(fn args ->  
    #   {time_micro2, result2} = :timer.tc(__MODULE__, :read_users_parallel, [16])
      

    #   time_ms2 = :erlang.round(time_micro2 / 1000)

    #   Logger.debug "result length=#{inspect length(result2)} #{time_ms2}ms"

    # end)


    # list1 = read_users()
    # list2 = read_users_parallel(1)
    # IO.puts ">> read_users #{inspect length(list1)}"
    # IO.puts ">> read_users_parallel #{inspect length(list1)}"
    
    # result1 = Benchwarmer.benchmark( fn -> read_users() end)
    # result2 = Benchwarmer.benchmark( fn -> read_users_parallel(16) end)


    # throw(result)

    # result1 = Benchwarmer.benchmark( fn -> read_file("users") end)
    # result2 = Benchwarmer.benchmark( fn -> read_file_flow() end)
    # result3 = Benchwarmer.benchmark( fn -> read_file_async() end)

    # users = read_file_async("users")
    # visits = read_file_async("visits")
    # locations = read_file_async("locations")

    # a1 = hd(users)
    # b1 = hd(visits)
    # c1 = hd(locations)

    # IO.puts ">> a #{inspect a1}"
    # IO.puts ">> b #{inspect b1}"
    # IO.puts ">> c #{inspect c1}"

    conn = conn(:get, "/users/1487/visits?country=%D0%91%D0%BE%D0%BB%D0%B3%D0%B0%D1%80%D0%B8%D1%8F&fromDate=144080640", "")
           |> Router.call(@opts)

    Logger.debug "conn.status=#{inspect conn.status}"
    Logger.debug "conn.resp_body=#{inspect conn.resp_body}"
  end

  def read_users_flow() do
    Path.wildcard("./priv/data/users_*.json") # read()
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.flat_map(fn(x) ->
                      read_file(x, "users")
                     end)
    |> Enum.to_list()
  end

  def read_users_async() do
    Path.wildcard("./priv/data/users_*.json") # read()
    |> Enum.map(fn(x) ->
                  Task.async(fn() ->
                               read_file(x, "users")
                             end
                  )
                end)
    |> Enum.map(fn(x) ->
                  Task.await(x)
                end)
    |> List.flatten()
  end

  def read_file_async(file) do
    Path.wildcard("./priv/data/#{file}_*.json") # read()
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

  def read_users() do
    Path.wildcard("./priv/data/users_*.json") # read()
    |> Enum.map(fn(k) -> read_file(k, "users") end)
    |> Enum.into([])
    |> List.flatten()
  end

  def read_file(file) do
    Path.wildcard("./priv/data/#{file}_*.json") # read()
    |> Enum.map(fn(k) -> read_file(k, file) end)
    |> Enum.into([])
    |> List.flatten()
  end

  def read_file(file_name, obj_name) do
    map = File.read!(file_name)
    |> Poison.decode!()

    map[obj_name]
  end


end

    # параллельный запуск через Flow
    # li = [1,2,3,4,5,6,7,8,9,10]
    # result = li
    # |> Flow.from_enumerable()
    # |> Flow.partition(stages: 30)
    # |> Flow.flat_map(fn(x) ->
    #                    IO.puts ">> map x=#{inspect x} self=#{inspect self()} start"
    #                    :timer.sleep(2000)
    #                    IO.puts ">> map x=#{inspect x} self=#{inspect self()} end"
    #                    [x * 2]
    #                  end)
    # |> Enum.to_list()
    # IO.puts ">>>>>>> result = #{inspect result}"

    # # параллельный запуск через Flow
    # fn1 = fn(x) ->
    #        IO.puts ">> map x=#{inspect x} self=#{inspect self()} start"
    #        :timer.sleep(2000)
    #        IO.puts ">> map x=#{inspect x} self=#{inspect self()} end"
    #        [x * 2]
    #      end

    # li = [1,2,3,4,5,6,7,8,9,10]
    # result = li
    # |> Enum.map(fn(x) ->
    #               Task.async(
    #                 fn() ->
    #                    IO.puts ">> map x=#{inspect x} self=#{inspect self()} start"
    #                    :timer.sleep(2000)
    #                    IO.puts ">> map x=#{inspect x} self=#{inspect self()} end"
    #                    x * 2
    #                 end
    #               )
    #             end)
    # |> Enum.map(fn(x) ->
    #               Task.await(x)
    #             end)

    # IO.puts ">>>>>>> result = #{inspect result}"
