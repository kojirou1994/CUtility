public protocol CStringConvertible: ~Copyable {
  func withUnsafeCString<Result, E: Error>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result
}

extension String: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try toTypedThrows(E.self) {
      try withCString(body)
    }
  }
}

extension Substring: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try toTypedThrows(E.self) {
      try withCString(body)
    }
  }
}

extension UnsafeRawPointer: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafeMutableRawPointer: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafePointer: CStringConvertible where Pointee == CChar {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(self)
  }
}

extension UnsafeMutablePointer: CStringConvertible where Pointee == CChar {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(self)
  }
}

extension StaticCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(cString)
  }
}

extension DynamicCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try body(cString)
  }
}

#if canImport(System)
import System

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E) -> Result where E : Error {
    try toTypedThrows(E.self) {
      try withCString(body)
    }
  }
}
#endif
