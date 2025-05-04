import NonEmpty

typealias AST = AbstractSyntaxTree

struct AbstractSyntaxTree {
    var nodes: NonEmptyArray<Node>

    indirect enum Node {
        case literal(Literal)
        case identifier(Identifier)
        case list(NonEmptyArray<Node>)
    }
}

//extension Parser<AST> {
//    init() {
//        self = Parser { input in
//            .literal.or(.identifier).or(.list)
//        }
//    }
//
//    private static var list: Self {
//        Parser<Token>
//            .punctuation(.parenthesisLeft)
//            .flatMap { _ in
//                Parser().some
//                    .flatMap { nodes in
//                        Parser<Token>
//                            .punctuation(.parenthesisRight)
//                            .map { _ in AST(nodes: [.list(nodes.map(\.nodes))]) }
//                    }
//            }
//    }
//
//    private static var literal: Self {
//        Self { input in
//            if case let .literal(value) = input.first {
//                (output: .literal(value), rest: input.dropFirst())
//            } else {
//                nil
//            }
//        }
//    }
//
//    private static var identifier: Self {
//        Self { input in
//            if case let .identifier(value) = input.first {
//                (output: .identifier(value), rest: input.dropFirst())
//            } else {
//                nil
//            }
//        }
//    }
//}
