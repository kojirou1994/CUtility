@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func toTypedThrows<Result, E: Error>(_ error: E.Type, _ body: () throws(any Error) -> Result) throws(E) -> Result {
  do {
    return try body()
  } catch let e as E {
    throw e
  } catch {
    fatalError()
  }
}
