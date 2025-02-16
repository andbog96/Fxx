enum ScanError: Error {
    case parsingFailed(line: Int, column: Int)
}

func scan(_ source: String) throws -> [Lexeme] {
    try source
        .split(whereSeparator: \.isNewline)
        .enumerated()
        .flatMap { (lineIndex, line) in
            var lexemes = [] as [Lexeme]
            var startIndex = line.startIndex
            for columnIndex in line.indices {
                if let singleCharPredefined = Lexeme.Token.Predefined(rawValue: String(line[columnIndex...columnIndex])) {
                    if startIndex != columnIndex {
                        let candidate = String(line[startIndex..<columnIndex])
                        let token: Lexeme.Token
                        if let predefined = Lexeme.Token.Predefined(rawValue: String(line[startIndex..<columnIndex])) {
                            if predefined == .comment {
                                return lexemes
                            } else {
                                token = .predefined(predefined)
                            }
                        } else if candidate.first?.isLetter == true,
                                  candidate.allSatisfy(\.isLetter || \.isNumber) {
                            token = .identifier(candidate)
                        } else if let value = Int(candidate) {
                            token = .integer(value)
                        } else { // Add Real
                            throw ScanError.parsingFailed(line: lineIndex, column: columnIndex)
                        }
                        lexemes += [
                            Lexeme(
                                token: token,
                                span: Lexeme.Span(line: lineIndex, range: startIndex...columnIndex - 1)
                            )
                        ]
                    }
                    if singleCharPredefined != .whitespace {
                        lexemes += [
                            Lexeme(
                                token: .predefined(singleCharPredefined),
                                span: Lexeme.Span(line: lineIndex, range: columnIndex...columnIndex)
                            )
                        ]
                    }
                    startIndex = line.index(after: columnIndex)
                }
            }

            return lexemes
        }
}

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
            case comment = "//"
            case whitespace = " "
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
