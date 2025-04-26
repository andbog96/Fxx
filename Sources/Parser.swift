import NonEmpty

struct Parser<Output> {
    var parse: (_ input: ArraySlice<Token>) -> (output: Output, rest: ArraySlice<Token>)?
}

extension Parser {
    func or(_ other: Self) -> Self {
        Parser { input in
            parse(input) ?? other.parse(input)
        }
    }
}

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
}
