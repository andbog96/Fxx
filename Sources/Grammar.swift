import NonEmpty

enum Punctuation: Character {
    case parenthesisLeft = "("
    case parenthesisRight = ")"
    case quoteSign = "'"
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

enum Literal: Equatable {
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

extension Literal: CustomStringConvertible {
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
