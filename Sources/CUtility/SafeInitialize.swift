@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func safeInitialize<T, E: Error>(_ body: (inout T?) throws(E) -> Void) throws(E) -> T {
  var temp: T?
  do {
    try body(&temp)
  } catch {
    assert(temp == nil, "Initialization failed but the value is filled, which may cause memory leak.")
    throw error
  }
  guard let v = temp else {
    assertionFailure("Initialization successed but the value is still nil, check your code.")
    return temp.unsafelyUnwrapped
  }
  return v
}
