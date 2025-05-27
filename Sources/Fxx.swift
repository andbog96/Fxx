import ArgumentParser

@main
struct Fxx: ParsableCommand {
    @Argument(help: "Source file to run")
    var inputFileName: String

    mutating func run() throws {
        let input = try String(contentsOfFile: inputFileName, encoding: .utf8)
        let lexemes = try Lexeme.scan(from: input)
        let (ast, _) = try Parser<AST>().run(lexemes[...])
        print(ast)
        let program = try Program(ast: ast)
        let output = try Interpreter.run(program: program)
        print(output)
    }
}
