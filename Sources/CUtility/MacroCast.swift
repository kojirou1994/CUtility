@inlinable @inline(__always)
public func macroCast<T, U>(_ macroValue: T) -> U where T: FixedWidthInteger, U: BinaryInteger {
  let bitsContainer: UInt64
  if macroValue.signum() == -1 {
    let extraBitCount = UInt64.bitWidth - T.bitWidth
    bitsContainer = (UInt64(truncatingIfNeeded: macroValue) << extraBitCount) >> extraBitCount
  } else {
    bitsContainer = numericCast(macroValue)
  }

  let result = U(truncatingIfNeeded: bitsContainer)

  return result
}
