import CUtility

extension Array: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {
    self = try .init(ContiguousArray<Element>(bytesCapacity: capacity, initializingBufferWith: initializer))
  }

}

extension ContiguousArray: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {
    assert(capacity % MemoryLayout<Element>.stride == 0, "capacity not well-calculated?")

    let count = capacity / MemoryLayout<Element>.stride

    #if !$Embedded
    self = try toTypedThrows(E.self) {
      try Self(unsafeUninitializedCapacity: count) { buffer, initializedCount throws(E) in
        initializedCount = try initializer(.init(buffer)) / MemoryLayout<Element>.stride
      }
    }
    #else
    var array = Self(unsafeUninitializedCapacity: count) { buffer, initializedCount in
      UnsafeMutableRawBufferPointer(buffer).initializeMemory(as: UInt8.self, repeating: 0) // all set to 0
      initializedCount = count
    }
    let result: Result<Int, E> = array.withUnsafeMutableBytes { buffer in
      do throws(E) {
        return .success(try initializer(buffer) / MemoryLayout<Element>.stride)
      } catch {
        return .failure(error)
      }
    }
    let initializedCount = try result.get()
    array.removeLast(initializedCount - count) // remove extra elements
    self = array
    #endif
  }

}
