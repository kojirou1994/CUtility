public struct NullTerminatedArray<T>: Sequence, IteratorProtocol {

  private var current: UnsafePointer<T?>?

  public init(_ pointer: UnsafePointer<T?>?) {
    current = pointer
  }

  public mutating func next() -> UnsafePointer<T?>? {
    if _slowPath(current?.pointee == nil) {
      return nil
    }
    defer {
      current = current?.successor()
    }
    return current
  }

}

public struct NullKeyPathTerminatedArray<T, R>: Sequence, IteratorProtocol {

  private var current: UnsafePointer<T>
  private let keypath: KeyPath<T, R?>

  public init(_ pointer: UnsafePointer<T>, keypath: KeyPath<T, R?>) {
    current = pointer
    self.keypath = keypath
  }

  public mutating func next() -> UnsafePointer<T>? {
    if _slowPath(current.pointee[keyPath: keypath] == nil) {
      return nil
    }
    defer {
      current = current.successor()
    }
    return current
  }

}
