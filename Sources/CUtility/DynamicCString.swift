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
