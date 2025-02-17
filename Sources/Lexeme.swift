struct Lexeme {
    var token: Token
    var span: Span
}

extension Lexeme {
    enum Token {
        case identifier(String)
        case real(Double)
        case integer(Int)
        case predefined(Predefined)

        enum Predefined: String {
            case null
            case `true`
            case `false`
            case parenthesisLeft = "("
            case parenthesisRight = ")"
            case quote
            case quoteSign = "'"
            case setq
            case `func`
            case lambda
            case prog
            case cond
            case `while`
            case `return`
            case `break`
        }
    }

    struct Span {
        var line: Int
        var range: ClosedRange<Int>
    }
}
