#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif canImport(Android)
import Android
#elseif canImport(WASILibc)
import WASILibc
#endif

public struct DynamicCString: ~Copyable, @unchecked Sendable {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(cString: consuming UnsafeMutablePointer<CChar>) {
    self.cString = cString
    assert(length <= .max, "invalid cString!")
  }

  @usableFromInline
  internal let cString: UnsafeMutablePointer<CChar>

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public consuming func take() -> UnsafeMutablePointer<CChar> {
    let v = cString
    // don't release the string
    discard self
    return v
  }

  /// copy a new string
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var string: String {
    String(cString: cString)
  }

  /// strlen, O(n)
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var length: Int {
    UTF8._nullCodeUnitOffset(in: cString)
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  deinit {
    free(cString)
  }

}

public extension DynamicCString {

  // optimize for one-time string
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: String) -> Self {
    .init(cString: strdup(cString))
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: some CStringConvertible) -> Self {
    .init(cString: cString.withUnsafeCString { strdup($0) })
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: borrowing DynamicCString) -> Self {
    copy(cString: cString.cString)
  }

  @_alwaysEmitIntoClient
  @inlinable
  static func copy(bytes: some ContiguousUTF8Bytes) -> Self {
    .init(cString: bytes.withContiguousUTF8Bytes { buffer in
      strndup(buffer.baseAddress!, buffer.count)
    })
  }

}

extension DynamicCString {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public mutating func withMutableCString<Result: ~Copyable, E: Error>(_ body: (UnsafeMutablePointer<CChar>) throws(E) -> Result) throws(E) -> Result {
    try body(cString)
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public static func withTemporaryBorrowed<R: ~Copyable, E: Error>(cString: UnsafeMutablePointer<CChar>, _ body: (borrowing DynamicCString) throws(E) -> R) throws(E) -> R {
    let str = DynamicCString(cString: cString)
    do {
      let result = try body(str)
      _ = str.take()
      return result
    } catch {
      _ = str.take()
      throw error
    }
  }
}
