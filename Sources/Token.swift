import NonEmpty

enum Token: Equatable {
    case punctuation(Punctuation)
    case literal(Literal)
    case identifier(Identifier)
}

extension Token {
    init?(rawValue: NonEmptyString) {
        let value =
            Punctuation(rawValue: rawValue.first)
                .map(Self.punctuation)
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

extension Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .punctuation(let value):
            "Punctuation: \(value.rawValue)"
        case .literal(let value):
            "\(value)"
        case .identifier(let value):
            "Identifier: \(value)"
        }
    }
}
