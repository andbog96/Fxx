import NonEmpty

enum Punctuation: Character {
    case parenthesisLeft = "("
    case parenthesisRight = ")"
    case quoteSign = "'"
}

extension Punctuation: CustomStringConvertible {
    var description: String {
        String(rawValue)
    }
}

// MARK: - Identifier
struct Identifier {
    let rawValue: NonEmptyString

    init?(rawValue: NonEmptyString) {
        guard rawValue.first.isLetter,
              rawValue.allSatisfy(\.isLetter .|| \.isNumber) else {
            return nil
        }

        self.rawValue = rawValue
    }
}

extension Identifier: Equatable, Hashable {}

extension Identifier: CustomStringConvertible {
    var description: String {
        rawValue.rawValue
    }
}

// MARK: - Literal
enum Literal {
    case null(Null)
    case boolean(Boolean)
    case integer(Int)
    case real(Double)

    enum Null: NonEmptyString {
        case null
    }

    enum Boolean: NonEmptyString {
        case `true`
        case `false`
    }
}

extension Literal {
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

extension Literal: Equatable {}

extension Literal: CustomStringConvertible {
    var description: String {
        switch self {
        case .null(let value as Any),
             .boolean(let value as Any),
             .integer(let value as Any),
             .real(let value as Any):
            "\(value)"
        }
    }
}
