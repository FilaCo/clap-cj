package clap

import std.collection.{HashMap, none, ReadOnlyMap}
import std.env.getCommandLine

public struct Command {
    public let name: String
    public let version: ?String
    public let about: ?String
    let args: ReadOnlyMap<String, Arg>
    let subcommands: ReadOnlyMap<String, Command>

    Command(builder: CommandBuilder) {
        name = builder.getName()
        version = builder.getVersion()
        about = builder.getAbout()
        args = builder.getArgs()
        subcommands = builder.getSubcommands()
    }

    public static func builder(name: String): CommandBuilder {
        CommandBuilder(name)
    }

    public func getMatches(): ArgMatches {
        getMatches(getCommandLine())
    }

    public func getMatches<ArgsT, ArgT>(args: ArgsT): ArgMatches where ArgsT <: Iterable<ArgT>, ArgT <: ToString {
        Parser(this).parse(args)
    }
}

public class CommandBuilder {
    private var _version = None<String>
    private var _about = None<String>
    private var _args = HashMap<String, Arg>()
    private var _subcommands = HashMap<String, Command>()

    CommandBuilder(private var _name: String) {
    }

    public func name(name: String): This {
        _name = name

        this
    }

    public func name(factory: () -> String): This {
        name(factory())
    }

    public func version(version: String): This {
        _version = version

        this
    }

    public func version(factory: () -> String): This {
        version(factory())
    }

    public func about(about: String): This {
        _about = about

        this
    }

    public func about(factory: () -> String): This {
        about(factory())
    }

    public func arg(arg: Arg): This {
        _args.add(arg.name, arg)

        this
    }

    public func arg(factory: () -> Arg): This {
        arg(factory())
    }

    public func subcommand(command: Command): This {
        _subcommands.add(command.name, command)

        this
    }

    public func subcommand(factory: () -> Command): This {
        subcommand(factory())
    }

    public func getName(): String {
        _name
    }

    public func getVersion(): ?String {
        _version
    }

    public func getAbout(): ?String {
        _about
    }

    public func build(): Command {
        if (_version.isSome()) {
            arg {=> Arg.builder("version").short(r'V').long("version").action(ArgAction.Version).build()}
        }

        if (!_args.contains("help") && (_args.values() |>
            none {arg: Arg => arg.short == r'h' || arg.long == "help" || arg.action == ArgAction.Help})) {
            arg {=> Arg.builder("help").short(r'h').long("help").action(ArgAction.Help).build()}
        }

        Command(this)
    }

    func getArgs(): HashMap<String, Arg> {
        _args
    }

    func getSubcommands(): HashMap<String, Command> {
        _subcommands
    }
}
