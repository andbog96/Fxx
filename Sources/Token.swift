import NonEmpty

enum Token: Equatable {
    case punctuation(Punctuation)
    case keyword(Keyword)
    case literal(Literal)
    case identifier(Identifier)

    init?(rawValue: NonEmptyString) {
        let value =
            Punctuation(rawValue: rawValue.first)
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

extension Token {
    enum Punctuation: Character {
        case parenthesisLeft = "("
        case parenthesisRight = ")"
        case quoteSign = "'"
    }

    enum Keyword: NonEmptyString {
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

    enum Literal: Equatable {
        case null(Null)
        case boolean(Boolean)
        case integer(Int)
        case real(Double)

        init?(rawValue: NonEmptyString) {
            let value =
                Null(rawValue: rawValue)
                    .map(Self.null)
                ??
                Boolean(rawValue: rawValue)
                    .map(Self.boolean)
                ??
                Int(rawValue.rawValue)
                    .map(Self.integer)
                ??
                Double(rawValue.rawValue)
                    .map(Self.real)

            guard let value else {
                return nil
            }

            self = value
        }
    }

    struct Identifier: Equatable {
        let value: NonEmptyString

        init?(rawValue: NonEmptyString) {
            guard rawValue.first.isLetter,
                  rawValue.allSatisfy(\.isLetter .|| \.isNumber) else {
                return nil
            }

            self.value = rawValue
        }
    }
}

extension Token.Literal {
    enum Null: NonEmptyString {
        case null
    }

    enum Boolean: NonEmptyString {
        case `true`
        case `false`
    }
}

extension Token: CustomStringConvertible {
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

extension Token.Literal: CustomStringConvertible {
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
