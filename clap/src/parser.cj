package clap

protected class Parser {
    public Parser(cmd: Command) {}

    public func parse<ArgsT, ArgT>(args: ArgsT): ArgMatches where ArgsT <: Iterable<ArgT>, ArgT <: Any {
        ArgMatches()
    }
}
