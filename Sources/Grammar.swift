protocol Grammar {
    associatedtype Value
    associatedtype Input

    init(value: Value)

    static func checkInput(_: Input) -> Value?
}

extension Grammar {
    init?(_ input: Input) {
        guard let value = Self.checkInput(input) else {
            return nil
        }

        self.init(value: value)
    }
}

protocol SimpleGrammar: Grammar where Value == Input {
    static func checkInput(_: Input) -> Bool
}

extension SimpleGrammar {
    static func checkInput(_ input: Input) -> Value? {
        Self.checkInput(input) ? input : nil
    }
}

struct Program: SimpleGrammar {
    var value: [Element]

    static func checkInput(_ input: Input) -> Bool {
        !input.isEmpty
    }
}

struct List: SimpleGrammar {
    var value: [Element]

    static func checkInput(_ input: Input) -> Bool {
        !input.isEmpty
    }
}

enum Element {
    case atom(Atom)
    case literal(Literal)
    case list(List)
}

typealias Atom = Identifier

struct Identifier: SimpleGrammar {
    var value: [Inner]

    static func checkInput(_ input: Input) -> Bool {
        if case .letter = input.first { true } else { false }
    }

    enum Inner {
        case letter(Letter)
        case decimalDigit(DecimalDigit)
    }
}

struct Letter: SimpleGrammar {
    var value: Character

    static func checkInput(_ input: Input) -> Bool {
        input.isLetter
    }
}

enum Literal {
    case integer(sign: Sign, Integer)
    case real(sign: Sign, Real)
    case boolean(Boolean)
    case null

    enum Sign {
        case plus
        case minus
    }
}

struct DecimalDigit: Grammar {
    var value: UInt8

    static func checkInput(_ input: Character) -> UInt8? {
        UInt8(String(input))
    }
}

struct Integer: SimpleGrammar {
    var value: [DecimalDigit]

    static func checkInput(_ input: Input) -> Bool {
        !input.isEmpty
    }
}

struct Real {
    var left: Integer
    var right: Integer
}

typealias Boolean = Bool
