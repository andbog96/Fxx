struct Lexeme {
    var token: Token
    var span: Span
}

extension Lexeme {
    enum Token {
        case keyword(Keyword)
        case punctuation(Punctuation)
        case identifier(Identifier)
        case literal(Literal)
    }

    struct Span {
        var line: Int
        var range: ClosedRange<Int>
    }
}

extension Lexeme.Token {
    enum Keyword: String {
        case quote
        case setq
        case `func`
        case lambda
        case prog
        case cond
        case `while`
        case `return`
        case `break`
    }

    enum Punctuation: Character {
        case parenthesisLeft = "("
        case parenthesisRight = ")"
        case quoteSign = "'"
    }

    struct Identifier {
        let value: String

        init?(_ value: String) {
            guard value.first?.isLetter == true,
                  value.allSatisfy(\.isLetter || \.isNumber) else {
                return nil
            }

            self.value = value
        }
    }

    enum Literal {
        case real(Double)
        case integer(Int)
        case boolean(Boolean)
        case null(Null)
    }
}

extension Lexeme.Token.Literal {
    enum Boolean: String {
        case `true`
        case `false`
    }

    enum Null: String {
        case null
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

extension Lexeme.Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .keyword(let value):
            "Keyword: \(value)"
        case .punctuation(let value):
            "Punctuation: \(value)"
        case .identifier(let name):
            "Identifier: \(name)"
        case .literal(let value):
            "\(value)"
        }
    }
}

extension Lexeme.Token.Literal: CustomStringConvertible {
    var description: String {
        switch self {
        case .real(let value):
            "Real: \(value)"
        case .integer(let value):
            "Integer: \(value)"
        case .boolean(let value):
            value.rawValue
        case .null(let value):
            value.rawValue
        }
    }
}
