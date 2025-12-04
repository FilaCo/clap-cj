package clap

import registry.Registry

public class ArgMatches {
    public ArgMatches(private let _args: Registry) {}

    public func getOne<T>(name: String): ?T {
        _args.tryGet<T>(name)
    }

    public func getMany<T>(name: String): ?Array<T> {
        _args.tryGet<Array<T>>(name)
    }
}
