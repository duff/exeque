defmodule Exeque.Worker do

  def work_against(queue_name) do
    case Exeque.pop(queue_name) do
      nil -> nil
      job ->
        job.()
        work_against(queue_name)
    end
  end

end

