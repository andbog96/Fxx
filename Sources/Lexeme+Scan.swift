extension Lexeme {
    static func scan(from source: String) throws -> [Lexeme] {
        try source
            .split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            .enumerated()
            .lazy
            .map { index, line in
                (number: index + 1, line: line)
            }
            .map { number, line in
                (number: number, line: line.split(separator: "//").first ?? [])
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
                        word.splitKeepingSeparators(whereSeparator: compose(not, isNil, Token.Punctuation.init(rawValue:), \.character))
                    }
                    .map { word in
                        guard let first = word.first,
                              let last = word.last else {
                            throw ScanError.unexpected(lineNumber: lineNumber)
                        }

                        let span = Span(line: lineNumber, range: first.column...last.column)

                        guard let token = Token(rawValue: String(word.map(\.character))) else {
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
