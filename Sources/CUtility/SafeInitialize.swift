public func safeInitialize<T>(_ body: (inout T?) throws -> Void) throws -> T {
  var temp: T?
  do {
    try body(&temp)
  } catch {
    assert(temp == nil, "Initialization failed but the value is filled, which may cause memory leak.")
    throw error
  }
  guard let v = temp else {
    assertionFailure("Initialization successed but the value is still nil, check your code.")
    throw UnexpectedInitializationFailure()
  }
  return v
}

public struct UnexpectedInitializationFailure: Error {}
