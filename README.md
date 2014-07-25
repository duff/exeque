Exeque
======

Queue up a list of functions and specify how many workers should be used to run those functions.

## Motivation

I've had  cases where I had a list of a few hundred independent long running operations
that needed to happen.  In each of the cases, the operations couldn't all happen at once since they
depended on a finite set of resources.  Having 8 or so of them happen at once though can be a
significant performance boost.


## Installation / Dependency

Add exeque to your `mix.exs` dependencies with whatever version you'd like to depend on:

```elixir
def deps do
  [ {:exeque, "~> x.y.z"} ]
end
```


## Usage

You specify the queue name, the list of functions that need to be run, and how many workers you'd
like to be running at once to empty the queue.

``` elixir
def eggcellent(multiplier \\ 1) do
  sleep_time = 200 * multiplier
  IO.puts "Started - #{sleep_time} ms"
  :timer.sleep(sleep_time)
  IO.puts "Finished - #{sleep_time} ms"
end

jobs = [
  fn -> eggcellent    end,
  fn -> eggcellent(8) end,
  fn -> eggcellent(3) end,
  fn -> eggcellent    end,
  fn -> eggcellent(4) end,
  fn -> eggcellent    end,
  fn -> eggcellent    end,
]

Exeque.create_queue(:egg_queue)
Exeque.enque(:egg_queue, jobs)
Exeque.process(:egg_queue, 3)
```

The worker processes are created when you call `process/2`.  The function blocks until the
queue is empty.

You can also do it all in one function if you'd like:

``` elixir
Exeque.create_enque_and_process("queue_name", jobs, 8)
```

