public struct NullTerminatedArray<T>: Sequence, IteratorProtocol {

  @usableFromInline
  internal var current: UnsafePointer<T?>

  @export(implementation) @inline(__always)
  public init(_ pointer: UnsafePointer<T?>) {
    current = pointer
  }

  @export(implementation) @inline(__always)
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

  @usableFromInline
  internal var current: UnsafePointer<T>
  @usableFromInline
  internal let keypath: KeyPath<T, R?>

  @export(implementation) @inline(__always)
  public init(_ pointer: UnsafePointer<T>, keypath: KeyPath<T, R?>) {
    current = pointer
    self.keypath = keypath
  }

  @export(implementation) @inline(__always)
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
