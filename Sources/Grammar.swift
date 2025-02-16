struct Program {
    var value: [Element]

    init?(_ value: [Element]) {
        guard !value.isEmpty else {
            return nil
        }

        self.value = value
    }
}

struct List {
    var value: [Element]

    init?(_ value: [Element]) {
        guard !value.isEmpty else {
            return nil
        }

        self.value = value
    }
}

enum Element {
    case atom(Atom)
    case literal(Literal)
    case list(List)
}

typealias Atom = Identifier

struct Identifier {
    var value: [Inner]

    init?(_ value: [Inner]) {
        guard case .letter = value.first else {
            return nil
        }

        self.value = value
    }

    enum Inner {
        case letter(Letter)
        case decimalDigit(DecimalDigit)
    }
}

struct Letter {
    var value: Character

    init?(_ value: Character) {
        guard value.isLetter else {
            return nil
        }

        self.value = value
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

struct DecimalDigit {
    var value: UInt8

    init?(_ character: Character) {
        guard let value = UInt8(String(character)) else {
            return nil
        }

        self.value = value
    }
}

struct Integer {
    var value: [DecimalDigit]

    init?(_ value: [DecimalDigit]) {
        guard !value.isEmpty else {
            return nil
        }

        self.value = value
    }
}

struct Real {
    var left: Integer
    var right: Integer
}

typealias Boolean = Bool
