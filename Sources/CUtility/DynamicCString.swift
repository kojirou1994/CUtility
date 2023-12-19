#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

public struct DynamicCString: ~Copyable {

  @inlinable
  public init(cString: consuming UnsafeMutablePointer<CChar>) {
    self.cString = cString
  }

  @usableFromInline
  internal let cString: UnsafeMutablePointer<CChar>

  @inlinable
  public consuming func take() -> UnsafeMutablePointer<CChar> {
    let v = cString
    // don't release the string
    discard self
    return v
  }

  @inlinable
  deinit {
    free(cString)
  }

}

extension DynamicCString: Sendable {}

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
    .init(cString: cString.withCString { strdup($0) })
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
  @inlinable @inline(__always)
  public func withMutableCString<Result>(_ body: (UnsafeMutablePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(cString)
  }
}
