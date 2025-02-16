// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct Fxx: ParsableCommand {
    @Argument(help: "Source file to run")
    var inputFileName: String

    mutating func run() throws {
        let input = try String(contentsOfFile: inputFileName, encoding: .utf8)
        let lexemes = try scan(input)
        print(lexemes.map(\.token))
    }
}
