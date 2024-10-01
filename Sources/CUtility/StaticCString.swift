#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

public struct StaticCString: @unchecked Sendable {

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }
  
  /// don't release the string
  public let cString: UnsafePointer<CChar>
  
  /// copy a new string
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var string: String {
    String(cString: cString)
  }

}

extension StaticCString: Equatable, Comparable {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public static func == (lhs: Self, rhs: Self) -> Bool {
    strcmp(lhs.cString, rhs.cString) == 0
  }

  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public static func < (lhs: StaticCString, rhs: StaticCString) -> Bool {
    strcmp(lhs.cString, rhs.cString) < 0
  }
}

extension StaticCString: CVarArg {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public var _cVarArgEncoding: [Int] {
    cString._cVarArgEncoding
  }
}

extension StaticCString: Hashable {
  @_alwaysEmitIntoClient
  @inlinable @inline(__always)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(bytes: UnsafeRawBufferPointer(start: cString, count: UTF8._nullCodeUnitOffset(in: cString)))
  }
}
