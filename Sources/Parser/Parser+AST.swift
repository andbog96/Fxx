import NonEmpty

extension Parser<AST> {
    init() {
        self = Parser<AST.Node>()
            .some
            .map(AST.init(nodes:))
    }
}

extension Parser<AST.Node> {
    init() {
        self = .or(
            Parser<Literal>()
                .map(AST.Node.literal),
            Parser<Identifier>()
                .map(AST.Node.identifier),
            .quote
                .map(AST.Node.list),
            .list
                .map(AST.Node.list),
        )
    }

    private static var quote: Parser<NonEmptyArray<AST.Node>> {
        Parser<Punctuation>(.quoteSign)
            .ignore
            .flatMap { list }
            .map(
                NonEmpty.cons(
                    AST.Node.identifier(Identifier(keyword: .quote))
                )
            )
    }

    private static var list: Parser<NonEmptyArray<AST.Node>> {
        Parser<Punctuation>(.parenthesisLeft)
            .ignore
            .flatMap(\.some • Self.init)
            .flatMap { nodes in
                Parser<Punctuation>(.parenthesisRight)
                    .ignore
                    .map { nodes }
            }
    }

    // Тоже самое только императивно
    private static var list2: Parser<NonEmptyArray<AST.Node>> {
        .init { input in
            guard let (_, rest) = Parser<Punctuation>(.parenthesisLeft).parse(input),
                  let (nodes, rest) = Self().some.parse(rest),
                  let (_, rest) = Parser<Punctuation>(.parenthesisRight).parse(rest)
            else {
                return nil
            }

            return (nodes, rest)
        }
    }
}

private extension Identifier {
    init(keyword: Keyword) {
        rawValue = keyword.rawValue
    }
}

private extension NonEmpty where Collection: RangeReplaceableCollection {
    init(head: Element, tail: NonEmptyArray<Element>) {
        self = NonEmpty([head] + tail).unsafelyUnwrapped
    }

    static var cons: (_ head: Element) -> (_ tail: NonEmptyArray<Element>) -> Self {
        curry(NonEmpty.init(head:tail:))
    }
}
