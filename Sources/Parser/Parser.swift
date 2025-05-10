import NonEmpty

struct Parser<Output> {
    var parse: (_ input: ArraySlice<Token>) -> (output: Output, rest: ArraySlice<Token>)?
}

// MARK: Functor
extension Parser {
    func map<T>(_ transform: @escaping (Output) -> T) -> Parser<T> {
        flatMap(Parser<T>.init(output:) • transform)
    }
}

// MARK: Applicative
extension Parser {
    init(output: Output) {
        self.init { input in
            (output: output, rest: input)
        }
    }

    func apply<A, B>(
        to parser: @escaping @autoclosure () -> Parser<A>
    ) -> Parser<B>
    where Output == (A) -> B {
        flatMap { parser().map($0) }
    }
}

// MARK: Monad
extension Parser {
    func flatMap<T>(_ transform: @escaping (Output) -> Parser<T>) -> Parser<T> {
        Parser<T> { input in
            parse(input).flatMap { output, rest in
                transform(output).parse(rest)
            }
        }
    }
}

// MARK: Alternative
extension Parser {
    static var empty: Self {
        .init(parse: const(nil))
    }

    func or(_ other: @escaping @autoclosure () -> Self) -> Self {
        Parser { input in
            parse(input) ?? other().parse(input)
        }
    }

    // Zero or more
    var many: Parser<[Output]> {
        some.map(\.rawValue)
            .or(.init(output: []))
    }

    // One or more
    var some: Parser<NonEmptyArray<Output>> {
        map(NonEmpty.cons)
            .apply(to: many)
    }
}

extension Parser {
    var ignore: Parser<Void> {
        map { _ in () }
    }

    func parse(_ input: [Token]) -> (output: Output, rest: ArraySlice<Token>)? {
        parse(ArraySlice(input))
    }

    static func or(_ parsers: [Self]) -> Self {
        parsers.reduce(empty, { $0.or($1) })
    }

    static func or(_ parsers: Self...) -> Self {
        or(parsers)
    }
}

private extension NonEmpty where Collection: RangeReplaceableCollection {
    init(head: Element, tail: Collection) {
        self = NonEmpty([head] + tail).unsafelyUnwrapped
    }

    static var cons: (_ head: Element) -> (_ tail: Collection) -> Self {
        curry(NonEmpty.init(head:tail:))
    }
}
