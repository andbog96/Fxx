import NonEmpty

struct Parser<Output> {
    var parse: (_ input: ArraySlice<Token>) -> (output: Output, rest: ArraySlice<Token>)?
}

extension Parser {
    // Functor
    func map<T>(_ transform: @escaping (Output) -> T) -> Parser<T> {
        flatMap(Parser<T>.init(output:) • transform)
    }

    // Applicative
    init(output: Output) {
        self.init { rest in
            (output: output, rest: rest)
        }
    }

    func apply<A, B>(_ parser: @escaping @autoclosure () -> Parser<A>) -> Parser<B> where Output == (A) -> B {
        flatMap(parser().map)
    }

    // Monad
    func flatMap<T>(_ transform: @escaping @autoclosure () -> (Output) -> Parser<T>) -> Parser<T> {
        Parser<T> { input in
            parse(input).flatMap { output, rest in
                transform()(output).parse(rest)
            }
        }
    }

    // Alternative
    func or(_ other: Self) -> Self {
        Parser { input in
            parse(input) ?? other.parse(input)
        }
    }

    // Zero or more
    var many: Parser<[Output]> {
        some.map(\.rawValue)
            .or(Parser<[Output]>(output: []))
    }

    // One or more
    var some: Parser<NonEmptyArray<Output>> {
        map(NonEmpty.make).apply(many)
    }
}

private extension NonEmpty where Collection: RangeReplaceableCollection {
    init(head: Element, tail: [Element]) {
        self = NonEmpty([head] + tail).unsafelyUnwrapped
    }

    static func make(_ head: Element) -> (_ tail: [Element]) -> Self {
        { tail in
            NonEmpty(head: head, tail: tail)
        }
    }
}
