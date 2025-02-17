fileprivate let START_ONE_LINE_COMMENT = "//"

fileprivate func parseLine(_ lineIndex : Int, _ line : String) throws -> [Lexeme] {
    var lexemes : [Lexeme] = []
    var startIndex = line.startIndex
    for columnIndex in line.indices {
        if line[columnIndex].isWhitespace
            || Lexeme.Token.Predefined(rawValue: String(line[columnIndex...columnIndex])) != nil {
            let candidate = String(line[startIndex..<columnIndex])
            if !candidate.isEmpty {
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
                        throw ScanError.parsingFailed(line: lineIndex, column: rightIndex)
                    }

                lexemes += [
                        Lexeme(
                        token: token,
                        span: Lexeme.Span(line: lineIndex, range: leftIndex...rightIndex - 1)
                    )
                ]
            }
            if let singleCharPredefined = Lexeme.Token.Predefined(rawValue: String(line[columnIndex...columnIndex])) {
                let index = line.distance(from: line.startIndex, to: columnIndex)
                lexemes += [
                    Lexeme(
                        token: .predefined(singleCharPredefined),
                        span: Lexeme.Span(line: lineIndex, range: index...index)
                    )
                ]
            }    
            startIndex = line.index(after: columnIndex)
        }
    }
    return lexemes

}

func scan(_ source: String) throws -> [Lexeme] {
    return try source
    .split(whereSeparator: \.isNewline)
    .enumerated()
    .map{(index, line : String.SubSequence) in // start line from 1
        (index + 1, line)
    }
    .map{(index, line : String.SubSequence) in // remove texts after // 
        (index, line.split(separator: START_ONE_LINE_COMMENT, omittingEmptySubsequences: false).first!)
    }
    .filter{(_, line : Substring.SubSequence) in !line.isEmpty}  // delete empty string
    .map{(index, line : Substring.SubSequence) in // add imaginary whitespace to simplify parseLine
        (index, line + " ")
    }
    .flatMap(parseLine)
}
