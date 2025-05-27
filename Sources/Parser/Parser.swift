import NonEmpty

struct Parser<Output> {
    var run: (_ input: ArraySlice<Lexeme>) throws -> (output: Output, rest: ArraySlice<Lexeme>)
}

// MARK: Functor
extension Parser {
    func map<T>(_ transform: @escaping (Output) -> T) -> Parser<T> {
        flatMap(Parser<T>.init(output:) • transform)
    }
}

// MARK: Applicative
extension Parser {
    // pure
    init(output: Output) {
        self.init { input in
            (output: output, rest: input)
        }
    }

    func apply<A, B>(
        to parser: @escaping @autoclosure () -> Parser<A>
    ) -> Parser<B> where Output == (A) -> B {
        flatMap { parser().map($0) }
    }
}

// MARK: Monad
extension Parser {
    func flatMap<T>(_ transform: @escaping (Output) -> Parser<T>) -> Parser<T> {
        Parser<T> { input in
            let (output, rest) = try run(input)
            return try transform(output).run(rest)
        }
    }
}

// MARK: Alternative
extension Parser {
    func or(_ other: @escaping @autoclosure () -> Self) -> Self {
        Parser { input in
            do {
                return try run(input)
            } catch _ {
                return try other().run(input)
            }
        }
    }

    // Zero or more
    var many: Parser<[Output]> {
        some.map(\.rawValue)
            .or(.init(output: []))
    }

    // One or more
    var some: Parser<NonEmptyArray<Output>> {
        map(NonEmpty.construct)
            .apply(to: many)
    }
}

extension Parser {
    static func or(_ parsers: NonEmptyArray<Self>) -> Self {
        parsers.dropFirst()
            .reduce(parsers.first, { $0.or($1) })
    }
}

private extension NonEmpty where Collection: RangeReplaceableCollection {
    init(head: Element, tail: Collection) {
        self = NonEmpty([head] + tail).unsafelyUnwrapped
    }

    static var construct: (_ head: Element) -> (_ tail: Collection) -> Self {
        curry(NonEmpty.init(head:tail:))
    }
}
