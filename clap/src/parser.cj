package clap

import std.argopt.{ArgumentMode, ArgumentParseException, ArgumentSpec, parseArguments, ParsedArguments}
import std.collection.{collectArray, HashMap, map}
import registry.Registry

protected class Parser {
    Parser(private let cmd: Command) {}

    public func parse<ArgsT, ArgT>(args: ArgsT): ArgMatches where ArgsT <: Iterable<ArgT>, ArgT <: ToString {
        parse(args |> map {arg => arg.toString()} |> collectArray)
    }

    public func parse(args: Array<String>): ArgMatches {
        try {
            let argsSpec = rootCmd.args.values() |> map {arg: Arg => arg.toArgumentSpec()} |> collectArray
            let parsedArgs = parseArguments(args, rootArgsSpec)

            ArgMatches(processParsedArgs(parsedArgs), parseSubcommand())
        } catch (e: ArgumentParseException) {
            cmd.printUsage()
        }
    }

    private func processParsedArgs(parsedArgs: ParsedArguments): Registry {}

    private func parseSubcommand(parsedArgs: ParsedArguments): ?(String, Box<ArgMatches>) {
        if (parsedArgs.nonOptions.size < 1) {
            return None
        }
    }
}

extend Arg {
    func toArgumentSpec(): ArgumentSpec {
        let mode = action.toArgumentMode()
        let rawSpec = (short, long)
        match (rawSpec) {
            case (Some(short), Some(long)) => ArgumentSpec.Full(long, short, mode)
            case (Some(short), None) => ArgumentSpec.Short(short, mode)
            case (None, Some(long)) => ArgumentSpec.Long(long, mode)
            case _ => ArgumentSpec.NonOptions {_ =>}
        }
    }
}

extend ArgAction {
    func toArgumentMode(): ArgumentMode {
        match (this) {
            case Set | Append => ArgumentMode.RequiredValue
            case SetTrue | SetFalse | Help | Version => ArgumentMode.NoValue
            case Count => ArgumentMode.OptionalValue
        }
    }
}
