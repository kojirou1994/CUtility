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
    discard self
    return v
  }

  @inlinable
  deinit {
    cString.deallocate()
  }

}

extension DynamicCString: Sendable {}

public extension DynamicCString {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: UnsafePointer<CChar>) -> Self {
    .init(cString: strdup(cString))
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  static func copy(cString: StaticCString) -> Self {
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
