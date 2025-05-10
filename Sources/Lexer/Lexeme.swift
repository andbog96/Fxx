struct Lexeme {
    var token: Token
    var span: Span
}

extension Lexeme {
    struct Span {
        var line: Int
        var range: ClosedRange<Int>
    }
}

extension Lexeme: CustomStringConvertible {
    var description: String {
        token.description
    }
}

extension Lexeme: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(span.line) : \(span.range) \(token)"
    }
}
