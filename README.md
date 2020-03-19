Tide [![Hex.pm](https://img.shields.io/hexpm/v/tide)](https://hex.pm/packages/tide) [![Build Status](https://travis-ci.com/elct9620/tide.ex.svg?branch=master)](https://travis-ci.com/elct9620/tide.ex)
===

Similar to [elixir/export](https://github.com/fazibear/export) but design for asynchronous.

## Installation

Adding `tide` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tide, "~> 0.2.1"}
  ]
end
```

## Usage

Start `Tide.Supervisor` to create Ruby worker pool

```ex
children = [
  {Tide.Supervisor, root: :code.priv_dir(:app_name) |> Path.join("ruby"), file: "app"},
  # ...
]
options = [strategy: :one_for_one, name: __MODULE__]

Supervisor.start_link(children, options)
```

### Register Event

Create a Ruby script (e.g. `priv/ruby/app.rb`) and put your code

```ruby
# Immediately will use the return value
Elixir::Tide.on("say") do |name|
  reply :ok, "Hello #{name}"
end

# Async event use "Tide.Agent.emit"
Elixir::Tide.on("sleep") do |wait_time|
  sleep wait_time.to_i
  reply :ok, "I am awake!"
end
```

### Agent

Start a `Tide.Agent` to manage events

```ex
{:ok, pid} = Tide.Agent.start_link()
```

Execute event (return immediately)

```ex
{:ok, message } = Tide.Agent.exec(pid, "say", ["World"])
# => "Hello World"
```

Emit event (asynchronous, and managed by `Tide.Reaction`)

```ex
{:ok, message } = Tide.Agent.emit(pid, "sleep", [1])
# After 1 seconds
{:ok, message } =
  Tide.Agent.reaction(pid)
  |> Tide.Reaction.next

# => "I am awake!"
```

### Reaction

The `Tide.Reaction` is a queue collect the reply from Ruby. You can use it to prevent the `Tide.Agent.exec` blocking your process.

### State

The Erlport didn't support call Erlang function from Thread, and to ensure your Ruby script can recover from crash.
Use the `Tide.State` to persist the state and it will pass to Ruby by Tide.

```ex
Tide.Agent.state(pid)
|> Tide.State.put(:name, "Hello")
```

```ruby
Elixir::Tide.on("from_state") do
  puts "Hi, #{state[:name]}"
end
```

## Roadmap

* [x] Worker Pool
  * [x] Customize root directory by `root` options
  * [x] Customize main file by `file` options
  * [x] Customize initialize function by `function` options
  * [ ] Customize environment variable by `env` options
* [ ] User Defined Module
  * [ ] Customize `Tide.Reaction`
  * [ ] Customize `Tide.State`
  * [x] Customize `Tide.Supervisor`
  * [ ] Customize `Tide.Agent`
