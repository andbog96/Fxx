import NonEmpty

extension Parser<Token> {
    static func satisfy(_ predicate: @escaping (Token) -> Bool) -> Self {
        Parser { input in
            if let token = input.first,
               predicate(token) {
                (token, input.dropFirst())
            } else {
                nil
            }
        }
    }

    static func token(_ value: Token) -> Self {
        satisfy { token in
            token == value
        }
    }

    static func punctuation(_ value: Punctuation) -> Self {
        satisfy { token in
            token == .punctuation(value)
        }
    }

}
