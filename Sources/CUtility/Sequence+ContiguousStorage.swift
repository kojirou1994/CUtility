import SwiftFix

extension Sequence where Element: BitwiseCopyable {
  /// copy elements to stack
  /// - Parameters:
  ///   - capacity: element capacity
  ///   - body: maybe called multiple times
  @_alwaysEmitIntoClient @inlinable
  public func withContiguousStorageSegments<E: Error>(capacity: Int, _ body: (_ buffer: UnsafeBufferPointer<Element>) throws(E) -> Void) throws(E) {
    precondition(capacity > 0)

    try withUnsafeTemporaryAllocationTyped(of: Element.self, capacity: capacity) { stackBuffer throws(E) in
      var iterator = self.makeIterator()
      var currentOffset = 0

      while let value = iterator.next() {
        stackBuffer[currentOffset] = value
        currentOffset += 1
        if currentOffset == capacity {
          try body(.init(stackBuffer))
          currentOffset = 0
        }
      }
      if currentOffset > 0 {
        try body(.init(rebasing: stackBuffer.prefix(currentOffset)))
      }
    }
  }
}
