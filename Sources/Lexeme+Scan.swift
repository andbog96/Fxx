import NonEmpty

extension Lexeme {
    static func scan(from source: String) throws -> [Lexeme] {
        try source
            .split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            .enumerated()
            .lazy
            .map { index, line in
                (lineNumber: index + 1, line: line)
            }
            .map { lineNumber, line in
                (lineNumber: lineNumber, line: line.split(separator: "//").first ?? [])
            }
            .filter(compose(not, \.isEmpty, \.line))
            .flatMap { lineNumber, line in
                try line
                    .enumerated()
                    .map { index, character in
                        (column: index + 1, character: character)
                    }
                    .split(whereSeparator: \.character.isWhitespace)
                    .lazy
                    .flatMap { word in
                        word.splitKeepingSeparators(
                            whereSeparator: compose(not, isNil, Token.Punctuation.init(rawValue:), \.character)
                        )
                    }
                    .compactMap(NonEmpty.init(rawValue:))
                    .map { word in
                        let span = Span(line: lineNumber, range: word.first.column...word.last.column)

                        guard let token = Token(rawValue: NonEmptyString(word.map(\.character))) else {
                            throw ScanError.invalidToken(span: span)
                        }

                        return Lexeme(token: token, span: span)
                    }
            }
    }
}

private extension Collection {
    func splitKeepingSeparators(
        whereSeparator isSeparator: (Element) -> Bool
    ) -> [SubSequence] {
        var result = [] as [SubSequence]
        var currentChunkStartIndex = startIndex

        for index in indices where isSeparator(self[index]) {
            if currentChunkStartIndex < index {
                let chunk = self[currentChunkStartIndex..<index]
                result += [chunk]
            }
            result += [self[index...index]]
            currentChunkStartIndex = self.index(after: index)
        }

        if currentChunkStartIndex < endIndex {
            let lastChunk = self[currentChunkStartIndex..<endIndex]
            result += [lastChunk]
        }

        return result
    }
}

private extension NonEmptyString {
    init(_ nonEmptyElements: NonEmpty<[Character]>) {
        self.init(rawValue: String(nonEmptyElements.rawValue))!
    }
}
