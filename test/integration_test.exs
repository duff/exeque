defmodule IntegrationTest do
  use ExUnit.Case

  def eggcellent(multiplier \\ 1) do
    sleep_time = 200 * multiplier
    IO.puts "Started - #{sleep_time} ms"
    :timer.sleep(sleep_time)
    IO.puts "Finished - #{sleep_time} ms"
  end

  test "I don't know how to test this" do
    jobs = [
      fn -> eggcellent end,
      fn -> eggcellent(32) end,
      fn -> eggcellent(3) end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent(9) end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent(10) end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end,
      fn -> eggcellent end
    ]

    Exeque.create_queue(:egg_queue)
    Exeque.enque(:egg_queue, jobs)
    # Exeque.process(:egg_queue, 5)
  end

end
