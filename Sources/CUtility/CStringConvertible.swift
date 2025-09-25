public protocol CStringConvertible: ~Copyable, ~Escapable {
  func withUnsafeCString<R: ~Copyable, E: Error>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R
}

extension String: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    var v: R!
    try toTypedThrows(E.self) {
      try withCString { cString in
        v = try body(cString)
      }
    }
    return v
  }
}

// use with
// typealias StringLiteralType = StaticString
extension StaticString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    if hasPointerRepresentation {
      try body(UnsafeRawPointer(utf8Start).assumingMemoryBound(to: CChar.self))
    } else {
      // copy to stack!
      try safeInitialize { (result: inout Result<R, E>?) in
        withUTF8Buffer { utf8 in
          result = .init { () throws(E) -> R in
            try toTypedThrows(E.self) {
              try withUnsafeTemporaryAllocation(of: UInt8.self, capacity: utf8.count + 1) { string in
                _ = string.initialize(from: utf8)
                string[utf8.count] = 0

                return try body(UnsafeRawPointer(string.baseAddress!).assumingMemoryBound(to: CChar.self))
              }
            }
          }
        }
      }.get()
    }
  }
}

extension UnsafeRawPointer: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafeMutableRawPointer: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafePointer: CStringConvertible where Pointee == CChar {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(self)
  }
}

extension UnsafeMutablePointer: CStringConvertible where Pointee == CChar {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(self)
  }
}

extension StaticCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}

extension DynamicCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}
