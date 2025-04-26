import NonEmpty

typealias AST = AbstractSyntaxTree

struct AbstractSyntaxTree {
    var nodes: NonEmptyArray<Node>

    indirect enum Node {
        case keyword(Token.Keyword)
        case literal(Token.Literal)
        case identifier(Token.Identifier)
        case list(NonEmptyArray<Node>)
    }
}
