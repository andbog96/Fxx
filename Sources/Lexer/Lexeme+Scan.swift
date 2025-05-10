import NonEmpty

extension Lexeme {
    static func scan(from source: String) throws -> [Lexeme] {
        let lines = source
            .split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            .enumerated()
            .lazy
            .map { index, line in
                (lineNumber: index + 1, line: line)
            }
            .map { lineNumber, line in
                (lineNumber: lineNumber, line: line.split(separator: "//").first ?? [])
            }
            .filter(not • \.isEmpty • \.line)

        return try lines
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
                            whereSeparator: not • isNil • Punctuation.init(rawValue:) • \.character
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

private extension ArraySlice {
    func splitKeepingSeparators(
        whereSeparator isSeparator: (Element) -> Bool
    ) -> [SubSequence] {
        reduce([]) { partialResult, element in
            if !isSeparator(element),
               let lastResult = partialResult.last,
               lastResult.last.map(isSeparator) == false {
                partialResult.dropLast() + [lastResult + [element]]
            } else {
                partialResult + [[element]]
            }
        }
    }
}

private extension NonEmptyString {
    init(_ nonEmptyElements: NonEmptyArray<Character>) {
        self = NonEmpty(rawValue: String(nonEmptyElements.rawValue)).unsafelyUnwrapped
    }
}
