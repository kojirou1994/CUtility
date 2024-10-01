public protocol CStringConvertible: ~Copyable {
  func withUnsafeCString<R: ~Copyable, E: Error>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R
}

extension String: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try safeInitialize { (result: inout Result<R, E>?) in
      withCString { cString in
        result = .init { () throws(E) -> R in
          try body(cString)
        }
      }
    }.get()
  }
}

extension Substring: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try safeInitialize { (result: inout Result<R, E>?) in
      withCString { cString in
        result = .init { () throws(E) -> R in
          try body(cString)
        }
      }
    }.get()
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

#if canImport(System)
import System

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try safeInitialize { (result: inout Result<R, E>?) in
      withCString { cString in
        result = .init { () throws(E) -> R in
          try body(cString)
        }
      }
    }.get()
  }
}
#endif
