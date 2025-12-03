package clap

import std.collection.HashMap

protected class Parser {
    public Parser(cmd: Command) {}

    public func parse<ArgsT, ArgT>(args: ArgsT): ArgMatches where ArgsT <: Iterable<ArgT>, ArgT <: ToString & Any {
        ArgMatches(HashMap(), None)
    }
}
