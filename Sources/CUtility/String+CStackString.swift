extension String {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init<T>(cStackString: __shared T, isNullTerminated: Bool = true) {
    precondition(MemoryLayout<T>.size > 0)
    self = withUnsafeBytes(of: cStackString) { buffer in
      if isNullTerminated {
        let cString = buffer.bindMemory(to: CChar.self).baseAddress.unsafelyUnwrapped
        assert(UTF8._nullCodeUnitOffset(in: cString) < buffer.count, "The C stack string is not null-terminated!")
        return String(cString: cString)
      } else {
        return String(decoding: buffer, as: UTF8.self)
      }
    }
  }

}
