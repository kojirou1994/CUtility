public struct NullTerminatedArray<T>: Sequence, IteratorProtocol {

  private var current: UnsafePointer<T>?

  public init(_ pointer: UnsafePointer<T>?) {
    current = pointer
  }

  @inline(__always)
  public mutating func next() -> UnsafePointer<T>? {
    if _slowPath(current == nil) {
      return nil
    }
    defer {
      current = current?.successor()
    }
    return current
  }

}
