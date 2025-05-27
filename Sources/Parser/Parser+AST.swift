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
        self = .or([
            Parser<Literal>()
                .map(AST.Node.literal),
            Parser<Identifier>()
                .map(AST.Node.identifier),
            .list,
            .quote,
        ])
    }

    private static var list: Self {
        Parser<Punctuation>(.parenthesisLeft)
            .map(ignore)
            .flatMap(\.many • Self.init)
            .flatMap { nodes in
                Parser<Punctuation>(.parenthesisRight)
                    .map(ignore)
                    .map { nodes }
            }
            .map(AST.Node.list)
    }

    // Тоже самое только императивно
    private static var list2: Self {
        Parser { input in
            if case let (_, rest) = try Parser<Punctuation>(.parenthesisLeft).run(input),
               case let (nodes, rest) = try Self().many.run(rest),
               case let (_, rest) = try Parser<Punctuation>(.parenthesisRight).run(rest) {
                let list = AST.Node.list(nodes)
                return (list, rest)
            }
        }
    }

    private static var quote: Self {
        Parser<Punctuation>(.quoteSign)
            .map(ignore)
            .flatMap(Self.init)
            .map { node in
                let quoteId = AST.Node.identifier(Identifier(specialForm: .quote))
                return if case .list(let list) = node {
                    [quoteId] + list
                } else {
                    [quoteId, node]
                }
            }
            .map(AST.Node.list)
    }
}

private extension Identifier {
    init(specialForm: Program.Element.SpecialForm) {
        rawValue = specialForm.rawValue
    }
}
