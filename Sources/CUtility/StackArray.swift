public struct StackArray<Value, Element> {
  public var value: Value

  @inlinable
  public init(value: Value, _ type: Element.Type = Element.self) {
    assert(MemoryLayout<Value>.stride > 0)
    assert(MemoryLayout<Element>.stride > 0)
    assert(MemoryLayout<Value>.stride % MemoryLayout<Element>.stride == 0)
    self.value = value
    assert(!isEmpty, "Meaningless empty array")
  }
}

extension StackArray: Collection, RandomAccessCollection {

  @inlinable
  public var count: Int {
    MemoryLayout<Value>.stride / MemoryLayout<Element>.stride
  }

  @inlinable
  public var startIndex: Int { 0 }

  @inlinable
  public var endIndex: Int { count }

  public subscript(i: Int) -> Element {
    @inlinable
    get {
      precondition(i >= 0 && i < count, "Index out of range")
      return withUnsafeBytes(of: value) { buffer in
        buffer.baseAddress!.assumingMemoryBound(to: Element.self)[i]
      }
    }
  }

  @inlinable
  public func index(after i: Index) -> Index { i + 1 }

  @inlinable
  public func index(before i: Index) -> Index { i - 1 }
}

public typealias CStackArray4<Element> = StackArray<(Element, Element, Element, Element), Element>
