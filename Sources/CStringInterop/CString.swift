public typealias CString = CStringConvertible & ~Copyable & ~Escapable

extension DefaultStringInterpolation {
  @inlinable
  public mutating func appendInterpolation(_ cString: borrowing some CString) {
    appendInterpolation(cString.withUnsafeCString(String.init(cString: )))
  }
}
