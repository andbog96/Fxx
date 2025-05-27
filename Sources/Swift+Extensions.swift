infix operator .&& : LogicalConjunctionPrecedence

@inlinable
func .&& <T>(
    f: @escaping (T) -> Bool,
    g: @escaping (T) -> Bool
) -> (T) -> Bool {
    { f($0) && g($0) }
}

infix operator .|| : LogicalDisjunctionPrecedence

@inlinable
func .|| <T>(
    f: @escaping (T) -> Bool,
    g: @escaping (T) -> Bool
) -> (T) -> Bool {
    { f($0) || g($0) }
}

@inlinable
func print<T>(_ value: T) {
    Swift.print(value)
}

@inlinable
func debugPrint<T>(_ value: T) {
    Swift.debugPrint(value)
}

@inlinable
func not(_ value: Bool) -> Bool {
    !value
}

@inlinable
func isNil<T>(_ value: T?) -> Bool {
    value == nil
}

@inlinable
func ignore<T>(_: T) {}

@inlinable
func const<I, V>(_ value: V) -> (I) -> V {
    { _ in value }
}

@inlinable
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    { a in { b in f(a, b) } }
}

@inlinable
func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
    { a, b in f(a)(b) }
}

precedencegroup CompositionPrecedence {
    associativity: right
    higherThan: BitwiseShiftPrecedence
}

infix operator • : CompositionPrecedence

@inlinable
func • <T1, T2, T3>(
    _ f2: @escaping (T2) -> T3,
    _ f1: @escaping (T1) -> T2
) -> (T1) -> T3 {
    { x in f2(f1(x)) }
}

@inlinable
func • <T1, T2, T3>(
    _ f2: @escaping (T2) throws -> T3,
    _ f1: @escaping (T1) throws -> T2
) -> (T1) throws -> T3 {
    { x in try f2(f1(x)) }
}
