# erlang-examples
Contains the examples in my blog post [Introduction to Erlang](https://yalingunayer.com/blog/introduction-to-erlang).

## Prerequisites
- Erlang
- sh/bash (optional, for running `run.sh`)

## Examples
- `bar`: A simple app that demonstrates the use of modules
- `pokemon`: A simple app that demonstrates actorlike behavior of processes using pokemon
- `fizzbuzz`: A concurrent implementation of fizzbuzz
- `guess`: The Erlang implementation of my [Akka-based number guessing game](https://yalingunayer.com/blog/actor-based-number-guessing-game-in-akka/) from earlier
- `distributed`: Demonstration of communicating Erlang nodes using two apps that run simultaneously and send messages to each other
- `guess-otp`: An Erlang/OTP compliant version of `guess`
- `configured-apps`: A very basic Erlang/OTP app that demonstrates runtime configurations

## Running
To run an example, execute `run.sh` and pass it the name of the example (e.g. `./run.sh pokemon`).

Any additional arguments will be passed to the app's own runner (e.g. `./run.sh distributed-apps test`)

## License
MIT
