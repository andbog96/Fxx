import NonEmpty

enum Token {
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

extension Token: Equatable {}

extension Token: CustomStringConvertible {
    var description: String {
        switch self {
        case .punctuation(let value as Any),
                .literal(let value as Any),
                .identifier(let value as Any):
           "\(value)"
        }
    }
}
