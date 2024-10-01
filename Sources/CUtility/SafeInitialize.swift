@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func safeInitialize<T: ~Copyable, E: Error>(_ body: (inout T?) throws(E) -> Void) throws(E) -> T {
  var temp: T?
  do {
    try body(&temp)
  } catch {
    assert(temp == nil, "Initialization failed but the value is filled, which may cause memory leak.")
    throw error
  }
  guard let v = temp else {
    preconditionFailure("Initialization successed but the value is still nil, check your code.")
  }
  return v
}
