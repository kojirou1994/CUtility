/// read-only referenced c-string
public struct ReferenceCString: Copyable, BitwiseCopyable, ~Escapable {

  @_lifetime(borrow cString)
  @export(implementation)
  @inline(always)
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }

  @usableFromInline
  let cString: UnsafePointer<CChar>

  /// copy a new string
  @export(implementation)
  @inline(always)
  public var string: String {
    String(cString: cString)
  }

  /// strlen, O(n)
  @export(implementation)
  @inline(always)
  public var length: Int {
    UTF8._nullCodeUnitOffset(in: cString)
  }

}

extension ReferenceCString: CStringConvertible {
  @export(implementation)
  @inline(always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}
