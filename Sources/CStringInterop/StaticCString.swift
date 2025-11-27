public struct StaticCString: @unchecked Sendable {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }
  
  /// don't release the string
  public let cString: UnsafePointer<CChar>
  
  /// copy a new string
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var string: String {
    String(cString: cString)
  }

}

#if !$Embedded
extension StaticCString: CVarArg {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var _cVarArgEncoding: [Int] {
    cString._cVarArgEncoding
  }
}
#endif

extension StaticCString: Hashable {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(bytes: UnsafeRawBufferPointer(start: cString, count: UTF8._nullCodeUnitOffset(in: cString)))
  }
}

extension StaticCString: CStringConvertible {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func withUnsafeCString<R, E>(_ body: (UnsafePointer<CChar>) throws(E) -> R) throws(E) -> R where E : Error, R : ~Copyable {
    try body(cString)
  }
}
