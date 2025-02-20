enum Tokenizer {}

extension Tokenizer {
    static func scan(from source: String) throws -> [Lexeme] {
        try source
            .lazy
            .split(whereSeparator: \.isNewline)
            .map { line in // remove texts after //
                line.split(separator: "//").first ?? []
            }
            .enumerated()
            .filter(not • \.isEmpty • \.1)  // delete empty string
            .map { (index, line) in // add imaginary whitespace to simplify parseLine
                (index, line + " ")
            }
            .flatMap(parseLine)
    }

    private static func parseLine(index lineIndex: Int, line: ArraySlice<Character>) throws -> [Lexeme] {
        let lineNumber = lineIndex + 1

        var lexemes = [] as [Lexeme]
        var startIndex = line.startIndex

        for columnIndex in line.indices {
            let currentChar = line[columnIndex]
            let punctuation = Lexeme.Token.Punctuation(rawValue: currentChar)

            if currentChar.isWhitespace || punctuation != nil {
                if startIndex < columnIndex {
                    let candidate = String(line[startIndex..<columnIndex])
                    let leftIndex = line.distance(from: line.startIndex, to: startIndex)
                    let rightIndex = line.distance(from: line.startIndex, to: columnIndex)

                    let token =
                        Lexeme.Token.Keyword(rawValue: candidate)
                            .map(Lexeme.Token.keyword) ??
                        Lexeme.Token.Identifier(candidate)
                            .map(Lexeme.Token.identifier) ??
                        Int(candidate)
                            .map(Lexeme.Token.Literal.integer)
                            .map(Lexeme.Token.literal) ??
                        Double(candidate)
                            .map(Lexeme.Token.Literal.real)
                            .map(Lexeme.Token.literal)

                    guard let token else {
                        throw ScanError.parsingFailed(line: lineNumber, column: rightIndex)
                    }

                    lexemes += [
                        Lexeme(
                            token: token,
                            span: Lexeme.Span(line: lineNumber, range: ClosedRange(leftIndex..<rightIndex))
                        )
                    ]
                }

                if let punctuation {
                    let index = line.distance(from: line.startIndex, to: columnIndex)
                    lexemes += [
                        Lexeme(
                            token: .punctuation(punctuation),
                            span: Lexeme.Span(line: lineNumber, range: index...index)
                        )
                    ]
                }

                startIndex = line.index(after: columnIndex)
            }
        }

        return lexemes
    }
}
