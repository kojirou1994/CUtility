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

    self = try toTypedThrows(E.self) {
      try Self(unsafeUninitializedCapacity: count) { buffer, initializedCount in
        initializedCount = try initializer(.init(buffer)) / MemoryLayout<Element>.stride
      }
    }
  }

}
