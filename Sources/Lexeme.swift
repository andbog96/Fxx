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

        init?(rawValue: String) {
            guard let firstCharacter = rawValue.first else {
                return nil
            }

            let value =
                Punctuation(rawValue: firstCharacter)
                    .map(Self.punctuation)
                ??
                Keyword(rawValue: rawValue)
                    .map(Self.keyword)
                ??
                Literal(rawValue: rawValue)
                    .map(Self.literal)
                ??
                Identifier(rawValue: rawValue)
                    .map(Self.identifier)

            guard let value else {
                return nil
            }

            self = value
        }
    }

    struct Span {
        var line: Int
        var range: ClosedRange<Int>
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

        init?(rawValue: String) {
            let value =
                Null(rawValue: rawValue)
                    .map(Self.null)
                ??
                Boolean(rawValue: rawValue)
                    .map(Self.boolean)
                ??
                Int(rawValue)
                    .map(Self.integer)
                ??
                Double(rawValue)
                    .map(Self.real)

            guard let value else {
                return nil
            }

            self = value
        }
    }

    struct Identifier {
        let value: String

        init?(rawValue: String) {
            guard rawValue.first?.isLetter == true,
                  rawValue.allSatisfy(\.isLetter || \.isNumber) else {
                return nil
            }

            self.value = rawValue
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
