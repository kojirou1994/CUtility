public struct NullTerminatedArray<T>: Sequence, IteratorProtocol {

  @usableFromInline
  internal var current: UnsafePointer<T?>

  @inlinable
  public init(_ pointer: UnsafePointer<T?>) {
    current = pointer
  }

  @inlinable
  public mutating func next() -> UnsafePointer<T>? {
    if _slowPath(current.pointee == nil) {
      return nil
    }
    defer {
      current = current.successor()
    }
    return UnsafeRawPointer(current).assumingMemoryBound(to: T.self)
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
