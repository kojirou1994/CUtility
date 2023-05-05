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

  @_alwaysEmitIntoClient
  public var string: String {
    String(cString: cString)
  }

}

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
