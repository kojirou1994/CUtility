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

extension String {
  @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
  @_alwaysEmitIntoClient @inlinable @inline(__always)
  public static func create<E: Error>(unsafeUninitializedCapacity capacity: Int, initializingUTF8With initializer: (_ buffer: UnsafeMutableBufferPointer<UInt8>) throws(E) -> Int) throws(E) -> String {
    var errorOut: E?

    let str = String(unsafeUninitializedCapacity: capacity, initializingUTF8With: { buffer in
      do throws(E) {
        return try initializer(buffer)
      } catch {
        errorOut = error
        return 0
      }
    })
    if let errorOut {
      throw errorOut
    }
    return str
  }
}


extension ContiguousArray {
  @_alwaysEmitIntoClient @inlinable @inline(__always)
  public static func create<E: Error>(unsafeUninitializedCapacity: Int, initializingWith initializer: (_ buffer: inout UnsafeMutableBufferPointer<Element>, _ initializedCount: inout Int) throws(E) -> Void) throws(E) -> Self {
    var errorOut: E?

    let result = Self(unsafeUninitializedCapacity: unsafeUninitializedCapacity) { buffer, initializedCount in
      do throws(E) {
        try initializer(&buffer, &initializedCount)
      } catch {
        errorOut = error
        initializedCount = 0
      }
    }

    if let errorOut {
      throw errorOut
    }
    return result
  }
}

extension Sequence {
  @_alwaysEmitIntoClient @inlinable @inline(__always)
  public func withContiguousStorageIfAvailableTyped<R: ~Copyable, E: Error>(_ body: (_ buffer: UnsafeBufferPointer<Element>) throws(E) -> R) throws(E) -> R? {
    var result: Result<R, E>?
    withContiguousStorageIfAvailable { buffer in
      result = .init { () throws(E) in
        try body(buffer)
      }
    }
    return try result?.get()
  }
}
