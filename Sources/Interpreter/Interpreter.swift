struct Scope {
    var values = [:] as [Identifier: Program.Element]

    private let lookupParent: (_ value: Identifier) -> Program.Element?

    init(parent: Scope? = nil) {
        lookupParent = { value in
            parent?.lookup(value)
        }
    }

    func lookup(_ value: Identifier) -> Program.Element? {
        values[value] ?? lookupParent(value)
    }
}

extension Scope {
    static var global: Scope {
        var scope = Scope()
        scope.values = [:]

        return scope
    }
}

enum Interpreter {

    static func run(program: Program) throws -> Program.Element {
        var scope = Scope.global

        let results = try program.elements.map { element in
            let (result, newScope) = try evaluate(element: element, scope: scope)
            scope = newScope

            return result
        }

        return results.last
    }

    private static func evaluate(
        element: Program.Element,
        scope: Scope
    ) throws -> (
        result: Program.Element,
        scope: Scope
    ) {
        switch element {
        case .literal:
            (element, scope)

        case .identifier(let identifier):
            if let result = scope.lookup(identifier) {
                (result, scope)
            } else {
                throw InterpreterError.undefinedIdentifier(identifier)
            }

        case .specialForm,
             .predefinedFunction:
            throw InterpreterError.invalidArguments

        case .list(let list):
            try evaluate(list: list, scope: scope)
        }
    }

    private static func evaluate(
        list: [Program.Element],
        scope: Scope
    ) throws -> (
        result: Program.Element,
        scope: Scope
    ) {
        guard let firstElement = list.first else {
            return (.list([]), scope)
        }

        let arguments = try list.dropFirst()
            .map { argument in
                try evaluate(element: argument, scope: scope).result
            }

        return switch firstElement {
        case .specialForm(let specialForm):
            try evaluate(specialForm: specialForm, arguments: arguments, scope: scope)

        case .predefinedFunction:
            fatalError()

        case .identifier(let identifier):
            if let _ = scope.lookup(identifier) {

                fatalError()
            } else {
                throw InterpreterError.undefinedIdentifier(identifier)
            }

        case .literal,
             .list:
            throw InterpreterError.notCallable
        }
    }

    private static func evaluate(
        specialForm: Program.Element.SpecialForm,
        arguments: [Program.Element],
        scope: Scope
    ) throws -> (
        result: Program.Element,
        scope: Scope
    ) {
        switch specialForm {
        case .quote:
            (.list(arguments), scope)
//        case .setq:
            
        default:
            fatalError()
        }
    }

}
