import NonEmpty

extension Parser<Punctuation> {
    init(_ value: Punctuation) {
        self = Self.process { token in
            if .punctuation(value) == token {
                value
            } else {
                nil
            }
        }
    }
}

extension Parser<Literal> {
    init() {
        self = Self.process { token in
            if case .literal(let value) = token {
                value
            } else {
                nil
            }
        }
    }
}

extension Parser<Identifier> {
    init() {
        self = Self.process { token in
            if case .identifier(let value) = token {
                value
            } else {
                nil
            }
        }
    }
}

private extension Parser {
    static func process(_ match: @escaping (Token) -> Output?) -> Self {
        Parser { input in
            guard let lexeme = input.first else {
                throw ParseError.endOfInput
            }

            guard let output = match(lexeme.token) else {
                throw ParseError.unexpected(lexeme: lexeme)
            }

            return (output: output, rest: input.dropFirst())
        }
    }
}
