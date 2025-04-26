infix operator .&& : LogicalConjunctionPrecedence

@inlinable
public func .&& <T>(
    f: @escaping (T) -> Bool,
    g: @escaping (T) -> Bool
) -> (T) -> Bool {
    { f($0) && g($0) }
}

infix operator .|| : LogicalDisjunctionPrecedence

@inlinable
public func .|| <T>(
    f: @escaping (T) -> Bool,
    g: @escaping (T) -> Bool
) -> (T) -> Bool {
    { f($0) || g($0) }
}

@inlinable
public func print<T>(_ value: T) {
    Swift.print(value)
}

@inlinable
public func debugPrint<T>(_ value: T) {
    Swift.debugPrint(value)
}

@inlinable
public func not(_ value: Bool) -> Bool {
    !value
}

@inlinable
public func isNil<T>(_ value: T?) -> Bool {
    value == nil
}

@inlinable
public func const<I, V>(_ value: V) -> (I) -> V {
    { _ in value }
}

@inlinable
public func compose<T1, T2, T3>(
    _ f2: @escaping (T2) -> T3,
    _ f1: @escaping (T1) -> T2
) -> (T1) -> T3 {
    { x in f2(f1(x)) }
}

@inlinable
public func compose<T1, T2, T3, T4>(
    _ f3: @escaping (T3) -> T4,
    _ f2: @escaping (T2) -> T3,
    _ f1: @escaping (T1) -> T2
) -> (T1) -> T4 {
    { x in f3(f2(f1(x))) }
}

@inlinable
public func compose<T1, T2, T3, T4, T5>(
    _ f4: @escaping (T4) -> T5,
    _ f3: @escaping (T3) -> T4,
    _ f2: @escaping (T2) -> T3,
    _ f1: @escaping (T1) -> T2
) -> (T1) -> T5 {
    { x in f4(f3(f2(f1(x)))) }
}
