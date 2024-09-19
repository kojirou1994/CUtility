public struct StackArray<Value, Element> {
  public var value: Value

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(value: consuming Value, _ type: Element.Type = Element.self) {
    assert(MemoryLayout<Value>.stride > 0)
    assert(MemoryLayout<Element>.stride > 0)
    assert(MemoryLayout<Value>.stride % MemoryLayout<Element>.stride == 0)
    self.value = value
    assert(!isEmpty, "Meaningless empty array")
  }
}

extension StackArray: Collection, RandomAccessCollection {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var count: Int {
    MemoryLayout<Value>.stride / MemoryLayout<Element>.stride
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var startIndex: Int { 0 }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var endIndex: Int { count }

  public subscript(i: Int) -> Element {
    @_alwaysEmitIntoClient
    @inlinable @inline(__always)
    get {
      precondition(i >= 0 && i < count, "Index out of range")
      return withUnsafeBytes(of: value) { buffer in
        buffer.baseAddress!.assumingMemoryBound(to: Element.self)[i]
      }
    }
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func index(after i: Int) -> Int { i + 1 }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func index(before i: Int) -> Int { i - 1 }
}

public typealias CStackArray4<Element> = StackArray<(Element, Element, Element, Element), Element>
