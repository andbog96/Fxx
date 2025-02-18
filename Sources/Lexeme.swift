struct Lexeme {
    var token: Token
    var span: Span
}

extension Lexeme {
    enum Token {
        case identifier(String)
        case real(Double)
        case integer(Int)
        case predefined(Predefined)

        enum Predefined: String {
            case null
            case `true`
            case `false`
            case parenthesisLeft = "("
            case parenthesisRight = ")"
            case quote
            case quoteSign = "'"
            case setq
            case `func`
            case lambda
            case prog
            case cond
            case `while`
            case `return`
            case `break`
        }
    }

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
        "\(span.line) : \(span.range) \(token.description)"
    }
}

extension Lexeme.Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .identifier(let name):
            "Identifier: \(name)"
        case .real(let value):
            "Real: \(value)"
        case .integer(let value):
            "Integer: \(value)"
        case .predefined(let predefined):
            "Predefined: \(predefined.rawValue)"
        }
    }
}
