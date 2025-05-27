import NonEmpty

struct Program {
    var elements: NonEmptyArray<Element>

    indirect enum Element {
        case literal(Literal)
        case identifier(Identifier)
        case specialForm(SpecialForm)
        case predefinedFunction(PredefinedFunction)
        case list([Element])
    }
}

extension Program.Element {
    enum SpecialForm: NonEmptyString {
        case quote
        case setq
        case `func`
        case lambda
        case prog
        case cond
        case `while`
        case `return`
        case `break`
    }

    enum PredefinedFunction: NonEmptyString {
        case plus
        case minus
        case times
        case divide

        case head
        case tail
        case cons

        case equal
        case nonequal
        case less
        case lesseq
        case greater
        case greatereq

        case isint
        case isreal
        case isbool
        case isnull
        case isatom
        case islist

        case and
        case or
        case xor
        case not

        case eval
    }
}

extension Program {
    init(ast: AST) throws {
        elements = try ast.nodes.map(Element.init(node:))
    }
}

extension Program.Element {
    init(node: AST.Node) throws {
        self =
            switch node {
            case .literal(let value):
                .literal(value)

            case .identifier(let value):
                SpecialForm(rawValue: value.rawValue)
                    .map(Self.specialForm)
                ??
                PredefinedFunction(rawValue: value.rawValue)
                    .map(Self.predefinedFunction)
                ??
                .identifier(value)

            case .list(let list):
                .list(try list.map(Self.init(node:)))
            }
    }
}

extension Program.Element: CustomStringConvertible {
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
        case .specialForm(let value as Any),
             .predefinedFunction(let value as Any):
            "\(value)"
        }
    }
}
