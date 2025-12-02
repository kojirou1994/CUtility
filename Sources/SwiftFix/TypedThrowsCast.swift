// any Error is disabled when Embedded
#if $Embedded

@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func toTypedThrows<Result: ~Copyable, E: Error>(_ error: E.Type, _ body: () throws(E) -> Result) throws(E) -> Result {
  try body()
}

#else

@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func toTypedThrows<Result: ~Copyable, E: Error>(_ error: E.Type, _ body: () throws(any Error) -> Result) throws(E) -> Result {
  do {
    return try body()
  } catch let e as E {
    throw e
  } catch {
    fatalError()
  }
}

#endif

@_alwaysEmitIntoClient @_transparent
public func withUnsafeTemporaryAllocationTyped<R: ~Copyable, E: Error>(byteCount: Int, alignment: Int, _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R) throws(E) -> R {
  let result: Result<R, E> = withUnsafeTemporaryAllocation(byteCount: byteCount, alignment: alignment) { buffer in
    do throws(E) {
      return .success(try body(buffer))
    } catch {
      return .failure(error)
    }
  }

  return try result.get()
}

@_alwaysEmitIntoClient @_transparent
public func withUnsafeTemporaryAllocationTyped<T: ~Copyable, R: ~Copyable, E: Error>(of type: T.Type, capacity: Int, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> R) throws(E) -> R {
  let result: Result<R, E> = withUnsafeTemporaryAllocation(of: type, capacity: capacity) { buffer in
    do throws(E) {
      return .success(try body(buffer))
    } catch {
      return .failure(error)
    }
  }

  return try result.get()
}
