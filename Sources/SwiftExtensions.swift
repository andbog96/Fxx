@inlinable
public func && <T>(f: @escaping (T) -> Bool, g: @escaping (T) -> Bool) -> (T) -> Bool {
    { f($0) && g($0) }
}

@inlinable
public func || <T>(f: @escaping (T) -> Bool, g: @escaping (T) -> Bool) -> (T) -> Bool {
    { f($0) || g($0) }
}
