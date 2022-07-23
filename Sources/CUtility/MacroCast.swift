@inlinable @inline(__always)
public func macroCast<U>(_ macroValue: Int32) -> U where U: BinaryInteger {
  .init(truncatingIfNeeded: UInt32(bitPattern: macroValue))
}
