extension FixedWidthInteger {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  internal var bitsContainer: UInt64 {
    let bitsContainer: UInt64
    if signum() == -1 {
      let extraBitCount = UInt64.bitWidth - bitWidth
      bitsContainer = (UInt64(truncatingIfNeeded: self) << extraBitCount) >> extraBitCount
    } else {
      bitsContainer = UInt64(self)
    }
    return bitsContainer
  }
}

@_alwaysEmitIntoClient
@inlinable @inline(__always)
public func macroCast<T, U>(_ macroValue: T) -> U where T: FixedWidthInteger, U: FixedWidthInteger {
  #if !$Embedded
  if T.self == U.self {
    return macroValue as! U
  }
  #endif

  let bitsContainer = macroValue.bitsContainer
  let result = U(truncatingIfNeeded: bitsContainer)

  // check if we lost any bits
  precondition(result.bitsContainer == bitsContainer)

  return result
}

public protocol MacroRawRepresentable: RawRepresentable where RawValue: FixedWidthInteger {
}

public extension MacroRawRepresentable {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  init<T: FixedWidthInteger>(macroValue: T) {
    self.init(rawValue: macroCast(macroValue))!
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  init(macroValue: some RawRepresentable<some FixedWidthInteger>) {
    self.init(macroValue: macroValue.rawValue)
  }
}
