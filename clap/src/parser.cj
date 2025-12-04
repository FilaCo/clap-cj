package clap

import std.collection.{HashMap, map}
import registry.Registry

protected class Parser {
    public Parser(private let cmd: Command) {}

    public func parse<ArgsT, ArgT>(args: ArgsT): ArgMatches where ArgsT <: Iterable<ArgT>, ArgT <: ToString {
        for (arg in args |> map {r => r.toString()}) {
            match (arg) {
                case long where arg.startsWith("--") && arg.size > 2 => println("long: ${long}")
                case _ => println("unknown")
            }
        }

        ArgMatches(Registry.builder().build())
    }
}
