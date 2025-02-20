@inlinable
public func && <T>(f: @escaping (T) -> Bool, g: @escaping (T) -> Bool) -> (T) -> Bool {
    { f($0) && g($0) }
}

@inlinable
public func || <T>(f: @escaping (T) -> Bool, g: @escaping (T) -> Bool) -> (T) -> Bool {
    { f($0) || g($0) }
}

@inlinable
public func print<T>(value: T) {
    Swift.print(value)
}

@inlinable
public func debugPrint<T>(value: T) {
    Swift.debugPrint(value)
}

@inlinable
public func not(value: Bool) -> Bool {
    !value
}

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

// TODO: заменить на compose(...), попробовать написать через вариадики
infix operator • : CompositionPrecedence

@inlinable
public func • <A, B, C> (f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    { x in f(g(x)) }
}

@inlinable
public func • <B, C> (f: @escaping (B) -> C, g: @escaping () -> B) -> () -> C {
    { f(g()) }
}

@inlinable
public func • (f: @escaping () -> Void, g: @escaping () -> Void) -> () -> Void {
    { g(); f() }
}

@inlinable
public func • <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    { x in g(&x); f(&x) }
}

@inlinable
public func • <A, B, C> (f: @escaping (B) throws -> C, g: @escaping (A) throws -> B) -> (A) throws -> C {
    { x in try f(g(x)) }
}

@inlinable
public func • <B, C> (f: @escaping (B) throws -> C, g: @escaping () throws -> B) -> () throws -> C {
    { try f(g()) }
}

@inlinable
public func • (f: @escaping () throws -> Void, g: @escaping () throws -> Void) -> () throws -> Void {
    { try g(); try f() }
}

@inlinable
public func • <A>(f: @escaping (inout A) throws -> Void, g: @escaping (inout A) throws -> Void) -> (inout A) throws -> Void {
    { x in try g(&x); try f(&x) }
}
