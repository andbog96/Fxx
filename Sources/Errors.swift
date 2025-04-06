extension Lexeme {
    enum ScanError: Error {
        case invalidToken(span: Span)
        case unexpected(lineNumber: Int)
    }
}
