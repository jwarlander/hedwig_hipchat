# Hedwig HipChat Adapter

> A HipChat Adapter for [Hedwig](https://github.com/hedwig-im/hedwig), based
> on [Hedwig XMPP](https://github.com/hedwig-im/hedwig_xmpp)

## Getting started

Let's generate a new Elixir application with a supervision tree:

```
λ mix new alfred --sup
* creating README.md
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/alfred.ex
* creating test
* creating test/test_helper.exs
* creating test/alfred_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd alfred
    mix test

Run "mix help" for more commands.
```

Change into our new application directory:

```
λ cd alfred
```

Add `hedwig_hipchat` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:hedwig_hipchat, "~> 0.9.5"}]
end
```

Ensure `hedwig_hipchat` is started before your application:

```elixir
def application do
  [applications: [:hedwig_hipchat]]
end
```

### Generate our robot

```
λ mix deps.get
λ mix hedwig.gen.robot

Welcome to the Hedwig Robot Generator!

Let's get started.

What would you like to name your bot?: alfred

Available adapters

1. Hedwig.Adapters.HipChat
2. Hedwig.Adapters.Console
3. Hedwig.Adapters.Test

Please select an adapter: 1

* creating lib/alfred
* creating lib/alfred/robot.ex
* updating config/config.exs

Don't forget to add your new robot to your supervision tree
(typically in lib/alfred.ex):

    worker(Alfred.Robot, [])
```

### Supervise our robot

We'll want Alfred to be supervised and started when we start our application.
Let's add it to our supervision tree. Open up `lib/alfred.ex` and add the
following to the `children` list:

```elixir
worker(Alfred.Robot, [])
```

### Configuration

The next thing we need to do is configure our bot for our HipChat server. Open
up `config/config.exs` and let's take a look at what was generated for us:

```elixir
use Mix.Config

config :alfred, Alfred.Robot,
  adapter: Hedwig.Adapters.HipChat,
  name: "alfred",
  aka: "/",
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.GreatSuccess, []},
    {Hedwig.Responders.ShipIt, []}
  ]
```

So we have the `adapter`, `name`, `aka`, and `responders` set. The `adapter` is
the module responsible for handling all of the HipChat details like connecting
and sending and receiving messages over the network. The `name` is the name
that our bot will respond to, and _must be the bot account's full name, exactly
as registered in HipChat_. The `aka` (also known as) field is optional, but it
allows us to address our bot with an alias. By default, this alias is set to
`/`; _we'll need to change that (since `/` is used by the HipChat client), so
we'll use `!` instead_.

Finally we have `responders`. Responders are modules that provide functions that
match on the messages that get sent to our bot. We'll discuss this further in
a bit.

We'll need to provide a few more things in order for us to connect to our
HipChat server. We'll need to provide our bot's `jid` and `password` as well as
a list of rooms we want our bot to join once connected.

To find out your HipChat `jid`, go to https://your_org.hipchat.com/account/xmpp,
log in as the bot, and see _Account info / Jabber ID_.

On the same page you'll see the available rooms; combine the _XMPP/Jabber name_
with the _Account info / Conference (MUC) domain_ so that you get a full JID,
like "12345_some_room@conf.hipchat.com".

Let's see what this could look like:

```elixir
use Mix.Config

config :alfred, Alfred.Robot,
  adapter: Hedwig.Adapters.HipChat,
  # HipChat is particular about using our registered name, exactly as is
  name: "Alfred",
  # we needed to change this, remember?
  aka: "!",
  # this is the Jabber ID from hipchat
  jid: "12345_123456@chat.hipchat.com",
  # fill in the appropriate password for your bot
  password: "password",
  rooms: [
    # fill in the appropriate rooms for your HipChat server
    {"12345_some_room@conf.hipchat.com", []}
  ],
  responders: [
    {Hedwig.Responders.Help, []},
    {Hedwig.Responders.GreatSuccess, []},
    {Hedwig.Responders.ShipIt, []}
  ]
```

Great! We're ready to start our bot. From the root of our application, let's run
the following:

```
λ mix run --no-halt
```

This will start our application along with our bot. Our bot should connect to
the server and join the configured room(s). From there, we can connect with our
favourite HipChat client and begin sending messages to our bot.

Since we have the `Help` responder installed, we can say `Alfred help` (or the
shorter version using our `aka`, `!help`) and we should see a list of usage for
all of the installed responders.

## What's next?

Well, that's it for now. Make sure to read the [Hedwig Documentation](http://hexdocs.pm/hedwig) for more
details on writing responders and other exciting things!

## LICENSE

Copyright (c) 2015 Sonny Scroggin, Johan Wärlander.

Hedwig HipChat source code is licensed under the [MIT License](https://github.com/jwarlander/hedwig_hipchat/blob/master/LICENSE.md).
