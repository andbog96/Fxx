extension [Lexeme] {
    init(from source: String) throws {
        self = try source
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
}

private func parseLine(index lineIndex: Int, line: ArraySlice<Character>) throws -> [Lexeme] {
    let lineNumber = lineIndex + 1

    var lexemes = [] as [Lexeme]
    var startIndex = line.startIndex

    for columnIndex in line.indices {
        let currentChar = line[columnIndex]
        let singleCharPredefined = Lexeme.Token.Predefined(rawValue: String(currentChar))

        if currentChar.isWhitespace || singleCharPredefined != nil {
            if startIndex < columnIndex {
                let candidate = String(line[startIndex..<columnIndex])
                let leftIndex = line.distance(from: line.startIndex, to: startIndex)
                let rightIndex = line.distance(from: line.startIndex, to: columnIndex)

                let token: Lexeme.Token =
                    if let predefined = Lexeme.Token.Predefined(rawValue: candidate) {
                        .predefined(predefined)
                    } else if candidate.first?.isLetter == true,
                              candidate.allSatisfy(\.isLetter || \.isNumber) {
                        .identifier(candidate)
                    } else if let value = Int(candidate) {
                        .integer(value)
                    } else if let value = Double(candidate) {
                        .real(value)
                    } else {
                        throw ScanError.parsingFailed(line: lineNumber, column: rightIndex)
                    }

                lexemes += [
                    Lexeme(
                        token: token,
                        span: Lexeme.Span(line: lineNumber, range: ClosedRange(leftIndex..<rightIndex))
                    )
                ]
            }

            if let singleCharPredefined {
                let index = line.distance(from: line.startIndex, to: columnIndex)
                lexemes += [
                    Lexeme(
                        token: .predefined(singleCharPredefined),
                        span: Lexeme.Span(line: lineNumber, range: index...index)
                    )
                ]
            }

            startIndex = line.index(after: columnIndex)
        }
    }

    return lexemes
}
