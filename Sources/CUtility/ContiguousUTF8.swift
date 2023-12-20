import Foundation

public protocol ContiguousUTF8Bytes {
  /// Invokes the given closure with a buffer containing the UTF-8 code unit sequence (excluding the null terminator).
  func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R
}

extension StaticString: ContiguousUTF8Bytes {
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
    withUTF8Buffer { body(.init($0)) }
  }
}

extension String: ContiguousUTF8Bytes {
  @inlinable
  public func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
    var copy = self
    return copy.withUTF8 { body(.init($0)) }
  }
}

extension Substring: ContiguousUTF8Bytes {
  @inlinable
  public func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
    var copy = self
    return copy.withUTF8 { body(.init($0)) }
  }
}

extension ContiguousUTF8Bytes where Self: ContiguousBytes {
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
    withUnsafeBytes(body)
  }
}

extension ContiguousUTF8Bytes where Self: CStringConvertible {
  @inlinable @inline(__always)
  public func withContiguousUTF8Bytes<R>(_ body: (UnsafeRawBufferPointer) -> R) -> R {
    withCString { cString in
      body(.init(start: cString, count: strlen(cString)))
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
