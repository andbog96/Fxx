struct Lexeme {
    var token: Token
    var span: Span
}

extension Lexeme {
    enum Token {
        case punctuation(Punctuation)
        case keyword(Keyword)
        case literal(Literal)
        case identifier(Identifier)
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

extension Lexeme.Token {
    enum Punctuation: Character {
        case parenthesisLeft = "("
        case parenthesisRight = ")"
        case quoteSign = "'"
    }

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

    enum Literal {
        case null(Null)
        case boolean(Boolean)
        case integer(Int)
        case real(Double)
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
}

extension Lexeme.Token.Literal {
    enum Null: String {
        case null
    }

    enum Boolean: String {
        case `true`
        case `false`
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
        case .punctuation(let value):
            "Punctuation: \(value.rawValue)"
        case .keyword(let value):
            "Keyword: \(value)"
        case .literal(let value):
            "\(value)"
        case .identifier(let value):
            "Identifier: \(value)"
        }
    }
}

extension Lexeme.Token.Literal: CustomStringConvertible {
    var description: String {
        switch self {
        case .null(let value):
            "\(value)"
        case .boolean(let value):
            "Boolean: \(value)"
        case .integer(let value):
            "Integer: \(value)"
        case .real(let value):
            "Real: \(value)"
        }
    }
}
