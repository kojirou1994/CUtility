public struct StaticCString: @unchecked Sendable {

  @export(implementation)
  @inline(__always)
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }
  
  /// don't release the string
  public let cString: UnsafePointer<CChar>
  
  /// copy a new string
  @export(implementation)
  @inline(__always)
  public var string: String {
    String(cString: cString)
  }

}

#if !$Embedded
extension StaticCString: CVarArg {
  @export(implementation)
  @inline(__always)
  public var _cVarArgEncoding: [Int] {
    cString._cVarArgEncoding
  }
}
#endif

extension StaticCString: Hashable {
  @export(implementation)
  @inline(__always)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(bytes: UnsafeRawBufferPointer(start: cString, count: UTF8._nullCodeUnitOffset(in: cString)))
  }
}

extension StaticCString: CStringConvertible {
  @export(implementation)
  @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}
