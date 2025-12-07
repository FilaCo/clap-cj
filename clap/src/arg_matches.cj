package clap

import registry.Registry

public struct ArgMatches {
    ArgMatches(private let _args: Registry, private let _subcommand: ?(String, Box<ArgMatches>)) {}

    public prop subcommand: ?(String, Box<ArgMatches>) {
        get() {
            _subcommand
        }
    }

    public func getOne<T>(name: String): ?T {
        _args.tryGet<T>(name)
    }

    public func getMany<T>(name: String): ?Array<T> {
        _args.tryGet<Array<T>>(name)
    }
}
