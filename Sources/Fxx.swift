import ArgumentParser

@main
struct Fxx: ParsableCommand {
    @Argument(help: "Source file to run")
    var inputFileName: String

    mutating func run() throws {
        let input = try String(contentsOfFile: inputFileName, encoding: .utf8)
        let lexemes = try Lexeme.scan(from: input)
//        lexemes.forEach(print)
//        lexemes.forEach(debugPrint)

        let tokens = lexemes.map(\.token)
        let ast = Parser<AST>().parse(tokens)?.output
        debugPrint(ast!)
    }
}
