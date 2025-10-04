import CUtility

extension String: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {
    self = try toTypedThrows(E.self) {
      if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
        try String(unsafeUninitializedCapacity: capacity) { buffer in
          let realCount = try initializer(.init(buffer))
          if realCount > 0, buffer[realCount-1] == 0 {
            // remove trailing \0
            return realCount-1
          }
          return realCount
        }
      } else {
        try withUnsafeTemporaryAllocation(of: UInt8.self, capacity: capacity) { buffer in
          var realCount = try initializer(.init(buffer))
          if realCount > 0, buffer[realCount-1] == 0 {
            // remove trailing \0
            realCount -= 1
          }
          return String(decoding: buffer.prefix(realCount), as: UTF8.self)
        }
      }
    }
  }
  
}
