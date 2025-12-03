import CUtility

extension String: SyscallValue {

  @inlinable
  public init<E: Error>(bytesCapacity capacity: Int, initializingBufferWith initializer: (UnsafeMutableRawBufferPointer) throws(E) -> Int) throws(E) {

    func stackCopy() throws(E) -> String {
      try withUnsafeTemporaryAllocationTyped(of: UInt8.self, capacity: capacity) { buffer throws(E) in
        var realCount = try initializer(.init(buffer))
        if realCount > 0, buffer[realCount-1] == 0 {
          // remove trailing \0
          realCount -= 1
        }
        return String(decoding: buffer.prefix(realCount), as: UTF8.self)
      }
    }

    func initBody(_ buffer: UnsafeMutableBufferPointer<UInt8>) throws(E) -> Int {
      let realCount = try initializer(.init(buffer))
      if realCount > 0, buffer[realCount-1] == 0 {
        // remove trailing \0
        return realCount-1
      }
      return realCount
    }

    #if $Embedded
    // TODO: wait typed std
    self = if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
      try String.create(unsafeUninitializedCapacity: capacity, initializingUTF8With: initBody)
    } else {
      try stackCopy()
    }
    #else
    self = if #available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *) {
      try toTypedThrows(E.self) {
        try String(unsafeUninitializedCapacity: capacity, initializingUTF8With: initBody)
      }
    } else {
      try stackCopy()
    }
    #endif
  }
  
}
