defmodule Exeque do

  alias Exeque.Worker

  def create_queue(name) do
    case (Agent.start_link(fn -> [] end, name: name)) do
      { :ok, pid } -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def enque(queue_name, functions) when is_list(functions) do
    Agent.update(queue_name, fn(jobs) ->
      functions ++ jobs
    end)
  end

  def enque(queue_name, function) when is_function(function) do
    Agent.update(queue_name, fn(jobs) ->
      [ function | jobs ]
    end)
  end

  def process(queue_name, worker_count) do
    pids = Enum.map((1..worker_count), fn(_) ->
      spawn fn -> Worker.work_against(queue_name) end
    end)

    pids |> monitor |> wait_until_complete
  end

  def create_enque_and_process(queue_name, functions, worker_count) do
    create_queue(queue_name)
    enque(queue_name, functions)
    process(queue_name, worker_count)
  end


  def jobs(name) do
    Agent.get(name, fn(jobs) -> jobs end)
  end

  def pop(name) do
    Agent.get_and_update(name, &pop_it(&1))
  end


  defp pop_it([head|tail]) do
    { head, tail }
  end

  defp pop_it([]) do
    { nil, [] }
  end

  defp monitor(pids) do
    Enum.each(pids, fn(pid) ->
      Process.monitor(pid)
    end)
    pids
  end

  defp wait_until_complete(pids) do
    Enum.each(pids, fn(pid) ->
      receive do
        {:DOWN, _, _, ^pid, _} -> :ok
      end
    end)
  end
end
