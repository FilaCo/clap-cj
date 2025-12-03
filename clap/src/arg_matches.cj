package clap

import std.collection.ReadOnlyMap
import std.convert.Parsable

public class ArgMatches {
    public ArgMatches(private let _args: ReadOnlyMap<String, Array<String>>,
        private let _subcommand: ?(String, ArgMatches)) {}

    public prop subcommand: ?(String, ArgMatches) {
        get() {
            _subcommand
        }
    }

    public func getOne<T>(name: String): ?T where T <: Parsable<T> {
        if (let Some(values) <- _args.get(name)) {
            // values won't be empty
            return T.parse(values[0])
        }

        None
    }

    public func getMany<T>(name: String): ?Array<T> where T <: Parsable<T> {
        if (let Some(values) <- _args.get(name)) {
            return values.map(T.parse)
        }

        None
    }
}
