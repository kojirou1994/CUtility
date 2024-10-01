import Foundation

public protocol ContiguousUTF8Bytes: ~Copyable {
  /// Invokes the given closure with a buffer containing the UTF-8 code unit sequence (excluding the null terminator).
  func withContiguousUTF8Bytes<R, E: Error>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R
}

extension StaticString: ContiguousUTF8Bytes {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error {
    try toTypedThrows(E.self) {
      try withUTF8Buffer { buf in Result { try body(.init(buf)) } }.get()
    }
  }
}

extension String: ContiguousUTF8Bytes {
  @_alwaysEmitIntoClient
  @inlinable
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error {
    try toTypedThrows(E.self) {
      var copy = self
      return try copy.withUTF8 { try body(.init($0)) }
    }
  }
}

extension Substring: ContiguousUTF8Bytes {
  @_alwaysEmitIntoClient
  @inlinable
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error {
    try toTypedThrows(E.self) {
      var copy = self
      return try copy.withUTF8 { try body(.init($0)) }
    }
  }
}

extension ContiguousUTF8Bytes where Self: ContiguousBytes {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error {
    try toTypedThrows(E.self) {
      try withUnsafeBytes(body)
    }
  }
}

extension ContiguousUTF8Bytes where Self: CStringConvertible & ~Copyable {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R, E>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R where E : Error {
    try withUnsafeCString { cString throws(E) in
      try body(.init(start: cString, count: strlen(cString)))
    }
  }
}

extension UnsafeRawBufferPointer: ContiguousUTF8Bytes {}
extension UnsafeMutableRawBufferPointer: ContiguousUTF8Bytes {}
extension UnsafeBufferPointer: ContiguousUTF8Bytes where Element == UInt8 {}
extension UnsafeMutableBufferPointer: ContiguousUTF8Bytes where Element == UInt8 {}

extension Array: ContiguousUTF8Bytes where Element == UInt8 {}
extension ArraySlice: ContiguousUTF8Bytes where Element == UInt8 {}
extension CollectionOfOne: ContiguousUTF8Bytes where Element == UInt8 {}
extension ContiguousArray: ContiguousUTF8Bytes where Element == UInt8 {}
extension Data: ContiguousUTF8Bytes {}
extension DispatchData.Region: ContiguousUTF8Bytes {}
extension EmptyCollection: ContiguousUTF8Bytes where Element == UInt8 {}
extension Slice: ContiguousUTF8Bytes where Base: ContiguousBytes {}
