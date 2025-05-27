enum ScanError: Error {
    case invalidToken(span: Lexeme.Span)
}

enum ParseError: Error {
    case endOfInput
    case unexpected(lexeme: Lexeme)
}

extension ParseError: CustomStringConvertible {
    var description: String {
        switch self {
        case .endOfInput:
            "Unexpected end of input"
        case .unexpected(lexeme: let lexeme):
            "Unexpected lexeme: " + lexeme.debugDescription
        }
    }
}

enum InterpreterError: Error {
    case undefinedIdentifier(Identifier)
    case invalidArguments
    case notCallable
}
