enum ScanError: Error {
    case parsingFailed(line: Int, column: Int)
}
