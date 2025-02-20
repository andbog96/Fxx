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

@inlinable
public func compose<A, B, C>(
    _ f: @escaping (B) -> C,
    _ g: @escaping (A) -> B
) -> (A) -> C {
    { x in f(g(x)) }
}

@inlinable
public func compose<A, B, C, D>(
    _ f: @escaping (C) -> D,
    _ g: @escaping (B) -> C,
    _ h: @escaping (A) -> B
) -> (A) -> D {
    compose(f, compose(g, h))
}
