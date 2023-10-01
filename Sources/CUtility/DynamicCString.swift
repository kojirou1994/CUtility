public struct DynamicCString: ~Copyable {

  @inlinable
  public init(cString: consuming UnsafePointer<CChar>) {
    self.cString = cString
  }

  @usableFromInline
  internal let cString: UnsafePointer<CChar>

  @inlinable
  public consuming func take() -> UnsafePointer<CChar> {
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
