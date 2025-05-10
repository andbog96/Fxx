import NonEmpty

typealias AST = AbstractSyntaxTree

struct AbstractSyntaxTree {
    var nodes: NonEmptyArray<Node>

    indirect enum Node {
        case literal(Literal)
        case identifier(Identifier)
        case list(NonEmptyArray<Node>)
    }
}

extension AST: CustomStringConvertible {
    var description: String {
        nodes.map(\.description).joined(separator: "\n\n")
    }
}

extension AST.Node: CustomStringConvertible {
    var description: String {
        switch self {
        case .literal(let literal):
            "Literal: " + literal.description
        case .identifier(let identifier):
            "Identifier: " + identifier.description
        case .list(let nodes):
            "List:\n" +
            nodes.lazy
                .map(\.description)
                .flatMap { $0.split(separator: "\n") }
                .map { "    " + $0 }
                .joined(separator: "\n")
        }
    }
}
