defmodule ExequeTest do
  use ExUnit.Case

  test "create_queue" do
    assert is_pid(Exeque.create_queue(:queue_name))
  end

  test "create_queue with same name" do
    first = Exeque.create_queue(:queue_name)
    second = Exeque.create_queue(:queue_name)
    assert first == second
  end

  test "enque single function" do
    Exeque.create_queue(:queue_name)

    first = fn -> IO.puts "first" end
    second = fn -> IO.puts "second" end
    third = fn -> IO.puts "third" end

    Exeque.enque(:queue_name, first)
    assert [first] == Exeque.jobs(:queue_name)

    Exeque.enque(:queue_name, second)
    Exeque.enque(:queue_name, third)
    assert [third, second, first] == Exeque.jobs(:queue_name)
  end

  test "enque list of functions" do
    Exeque.create_queue(:queue_name)

    first = fn -> IO.puts "first" end
    second = fn -> IO.puts "second" end

    Exeque.enque(:queue_name, [first, second])

    assert [first, second] == Exeque.jobs(:queue_name)

    third = fn -> IO.puts "third" end
    fourth = fn -> IO.puts "fourth" end

    Exeque.enque(:queue_name, [third, fourth])
    assert [third, fourth, first, second] == Exeque.jobs(:queue_name)
  end

  test "enque to nonexistent queue" do
    assert {:noproc, _ } = catch_exit(Exeque.enque(:non_existent, fn -> IO.puts "Nice" end))
  end

  test "pop" do
    Exeque.create_queue(:queue_name)

    first = fn -> IO.puts "first" end
    second = fn -> IO.puts "second" end
    third = fn -> IO.puts "third" end

    Exeque.enque(:queue_name, [first, second, third])

    popped = Exeque.pop(:queue_name)
    assert popped == first
    assert [second, third] == Exeque.jobs(:queue_name)

    popped = Exeque.pop(:queue_name)
    assert popped == second
    assert [third] == Exeque.jobs(:queue_name)
  end

  test "pop when queue is empty" do
    Exeque.create_queue(:queue_name)
    assert Exeque.pop(:queue_name) == nil
    assert [] == Exeque.jobs(:queue_name)
  end

end
