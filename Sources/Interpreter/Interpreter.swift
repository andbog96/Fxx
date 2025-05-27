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
                (.identifier(identifier), scope)
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
            try evaluate(
                specialForm: specialForm,
                arguments: arguments,
                scope: scope
            )
        case .predefinedFunction(let predefinedFunction):
            try evaluate(
                predefinedFunction: predefinedFunction,
                arguments: arguments,
                scope: scope
            )
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
            return (.list(arguments), scope)
        case .setq:
            guard arguments.count == 2 else {
                throw InterpreterError.invalidArguments
            }

            if case let .identifier(variableName) = arguments.first,
                let value = arguments.last {
                var newScope = scope
                newScope.values[variableName] = value

                return (value, newScope)
            } else {
                throw InterpreterError.invalidArguments
            }

        default:
            fatalError()
        }
    }

    private static func evaluate(predefinedFunction: Program.Element.PredefinedFunction, arguments: [Program.Element], scope: Scope ) throws -> (result: Program.Element, scope: Scope) {
        switch predefinedFunction {
        case .plus:
            guard arguments.count == 2 else {
                throw InterpreterError.invalidArguments
            }

            if case let (.literal(leftValue), .literal(rightValue)) = (arguments.first, arguments.last) {
                let resultLiteral: Literal =
                    switch (leftValue, rightValue) {
                    case let (.real(left), .real(right)):
                        .real(left + right)

                    case let (.integer(left), .real(right)):
                        .real(Double(left) + right)

                    case let (.real(left), .integer(right)):
                        .real(left + Double(right))

                    case let (.integer(left), .integer(right)):
                        .integer(left + right)

                    default:
                        throw InterpreterError.invalidArguments
                    }
                return (.literal(resultLiteral), scope)
            } else {
                throw InterpreterError.invalidArguments
            }


        default:
            fatalError()
        }
    }

}
