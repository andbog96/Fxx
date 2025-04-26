import NonEmpty

typealias AST = AbstractSyntaxTree

indirect enum AbstractSyntaxTree {
    case literal(Literal)
    case identifier(Identifier)
    case list(NonEmptyArray<AbstractSyntaxTree>)
}
