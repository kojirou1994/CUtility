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

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: borrowing some CString) -> Self {
    .init(cString: cString.withUnsafeCString { strdup($0) })
  }

  @_alwaysEmitIntoClient
  @inlinable
  static func copy(bytes: borrowing some ContiguousUTF8Bytes & ~Copyable & ~Escapable) -> Self {
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
  public static func withTemporaryBorrowed<R: ~Copyable, E: Error>(cString: borrowing some CString, _ body: (borrowing DynamicCString) throws(E) -> R) throws(E) -> R {
    try cString.withUnsafeCString { cString throws(E) in
      let str = DynamicCString(cString: .init(mutating: cString)) // mutating but will be borrowing
      do throws(E) {
        let result = try body(str)
        _ = str.take()
        return result
      } catch {
        _ = str.take()
        throw error
      }
    }
  }

  /// temporally copy a null-terminated cstring from bytes
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public static func withTemporaryBorrowed<R: ~Copyable, E: Error>(bytes: borrowing some ContiguousUTF8Bytes & ~Copyable & ~Escapable, _ body: (borrowing DynamicCString) throws(E) -> R) throws(E) -> R {
    try toTypedThrows(E.self) {
      try bytes.withContiguousUTF8Bytes { buff in
        try withUnsafeTemporaryAllocation(of: UInt8.self, capacity: buff.count+1) { strBuff in
          let result = strBuff.initialize(from: buff)
          strBuff[result.index] = 0
          return try withTemporaryBorrowed(cString: UnsafeRawPointer(strBuff.baseAddress.unsafelyUnwrapped).assumingMemoryBound(to: CChar.self), body)
        }
      }
    }
  }
}
