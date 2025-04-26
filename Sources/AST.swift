import NonEmpty

typealias AST = AbstractSyntaxTree

indirect enum AbstractSyntaxTree {
    case keyword(Token.Keyword)
    case literal(Token.Literal)
    case identifier(Token.Identifier)
    case list(NonEmptyArray<AbstractSyntaxTree>)
}
