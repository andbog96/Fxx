import NonEmpty

extension Parser<Punctuation> {
    init(_ value: Punctuation) {
        self = Parser { input in
            if .punctuation(value) == input.first {
                (output: value, rest: input.dropFirst())
            } else {
                nil
            }
        }
    }
}

extension Parser<Literal> {
    init() {
        self = Parser { input in
            if case .literal(let value) = input.first {
                (output: value, rest: input.dropFirst())
            } else {
                nil
            }
        }
    }
}

extension Parser<Identifier> {
    init() {
        self = Parser { input in
            if case .identifier(let value) = input.first {
                (output: value, rest: input.dropFirst())
            } else {
                nil
            }
        }
    }
}
