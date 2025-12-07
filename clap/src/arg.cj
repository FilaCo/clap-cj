package clap

import std.collection.ArrayList
import std.deriving.Derive

public struct Arg {
    public let name: String
    public let help: ?String
    public let action: ArgAction
    public let short: ?Rune
    public let long: ?String
    public let defaultValue: ?Box<Any>
    public let valueName: String
    public let required: Bool

    Arg(builder: ArgBuilder) {
        name = builder.getName()
        help = builder.getHelp()
        action = builder.getAction()
        short = builder.getShort()
        long = builder.getLong()
        defaultValue = builder.getDefaultValue()
        valueName = builder.getValueName()
        required = builder.isRequired()
    }

    public static func builder(name: String): ArgBuilder {
        ArgBuilder(name)
    }
}

public class ArgBuilder {
    private var _help = None<String>
    private var _action = Set
    private var _short = None<Rune>
    private var _long = None<String>
    private var _defaultValue = None<Box<Any>>
    private var _valueName: String
    private var _required = false

    ArgBuilder(private var _name: String) {
        _valueName = _name.toAsciiUpper()
    }

    public func name(name: String): This {
        _name = name

        this
    }

    public func help(help: String): This {
        _help = help

        this
    }

    public func action(action: ArgAction): This {
        _action = action

        this
    }

    public func short(short: Rune): This {
        _short = short

        this
    }

    public func long(long: String): This {
        _long = long

        this
    }

    public func defaultValue<T>(defaultValue: T): This {
        _defaultValue = Box(defaultValue)

        this
    }

    public func valueName(valueName: String): This {
        _valueName = valueName

        this
    }

    public func required(required: Bool): This {
        _required = required

        this
    }

    public func getName(): String {
        _name
    }

    public func getHelp(): ?String {
        _help
    }

    public func getAction(): ArgAction {
        _action
    }

    public func getShort(): ?Rune {
        _short
    }

    public func getLong(): ?String {
        _long
    }

    protected func getDefaultValue<T>(): ?T {
        _defaultValue?.value as T
    }

    public func getValueName(): String {
        _valueName
    }

    public func isRequired(): Bool {
        _required
    }

    public func build(): Arg {
        Arg(this)
    }
}

@Derive[Equatable]
public enum ArgAction {
    Set | Append | SetTrue | SetFalse | Count | Help | Version
}
