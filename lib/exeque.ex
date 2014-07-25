defmodule Exeque do

  alias Exeque.Worker

  def create_queue(name, options \\ []) do
    case (Agent.start_link(fn -> [] end, name: name)) do
      { :ok, pid } -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def process(name, worker_count) do
    Enum.each((1..worker_count), fn(each) ->
      spawn fn -> Worker.work_against(name) end
    end)
  end

  def enque(name, functions) when is_list(functions) do
    Agent.update(name, fn(jobs) ->
      functions ++ jobs
    end)
  end

  def enque(name, function) when is_function(function) do
    Agent.update(name, fn(jobs) ->
      [ function | jobs ]
    end)
  end

  def jobs(name) do
    Agent.get(name, fn(jobs) -> jobs end)
  end

  def pop(name) do
    Agent.get_and_update(name, &pop_it(&1))
  end

  def create_and_process(queue_name, functions, worker_count) do
    create_queue(queue_name)
    enque(queue_name, functions)
    process(queue_name, worker_count)
  end

  defp pop_it([head|tail]) do
    { head, tail }
  end

  defp pop_it([]) do
    { nil, [] }
  end

end
