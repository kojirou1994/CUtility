/// read-only referenced c-string
public struct ReferenceCString: Copyable, BitwiseCopyable, ~Escapable {

  @_lifetime(borrow cString)
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }

  @usableFromInline
  let cString: UnsafePointer<CChar>

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

}

extension ReferenceCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}
