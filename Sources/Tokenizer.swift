enum Tokenizer {}

extension Tokenizer {
    static func scan(from source: String) throws -> [Lexeme] {
        try source
            .lazy
            .split(whereSeparator: \.isNewline)
            .map { line in // add newline to simplify parseLine
                line + "\n"
            }
            .map { line in // remove texts after //
                line.split(separator: "//").first ?? []
            }
            .enumerated()
            .filter(not • \.isEmpty • \.1)  // delete empty string
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
                    let leftIndex = line.distance(from: line.startIndex, to: startIndex)
                    let rightIndex = line.distance(from: line.startIndex, to: columnIndex)
                    let candidate = String(line[startIndex..<columnIndex])

                    let token: Lexeme.Token? =
                        .Keyword(rawValue: candidate)
                            .map(Lexeme.Token.keyword)
                        ??
                        (
                            .Null(rawValue: candidate)
                                .map(Lexeme.Token.Literal.null)
                            ??
                            .Boolean(rawValue: candidate)
                                .map(Lexeme.Token.Literal.boolean)
                            ??
                            Int(candidate)
                                .map(Lexeme.Token.Literal.integer)
                            ??
                            Double(candidate)
                                .map(Lexeme.Token.Literal.real)
                        )
                        .map(Lexeme.Token.literal)
                        ??
                        .Identifier(candidate)
                            .map(Lexeme.Token.identifier)

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
