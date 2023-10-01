#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

public struct StaticCString {

  @_alwaysEmitIntoClient
  public init(cString: UnsafePointer<CChar>) {
    self.cString = cString
  }

  public let cString: UnsafePointer<CChar>

  @inlinable
  public var string: String {
    String(cString: cString)
  }

}

extension StaticCString: Sendable {}

extension StaticCString: Equatable, Comparable {
  @inlinable @inline(__always)
  public static func == (lhs: Self, rhs: Self) -> Bool {
    strcmp(lhs.cString, rhs.cString) == 0
  }

  @inlinable @inline(__always)
  public static func < (lhs: StaticCString, rhs: StaticCString) -> Bool {
    strcmp(lhs.cString, rhs.cString) < 0
  }
}

extension StaticCString: CVarArg {
  @inlinable @inline(__always)
  public var _cVarArgEncoding: [Int] {
    cString._cVarArgEncoding
  }
}

extension StaticCString: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(bytes: UnsafeRawBufferPointer(start: cString, count: UTF8._nullCodeUnitOffset(in: cString)))
  }
}
