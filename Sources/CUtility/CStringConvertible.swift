public protocol CStringConvertible {

  func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result
}

extension String: CStringConvertible {}

extension Substring: CStringConvertible {}

extension UnsafeRawPointer: CStringConvertible {
  @inlinable @inline(__always)
  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafeMutableRawPointer: CStringConvertible {
  @inlinable @inline(__always)
  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(self.assumingMemoryBound(to: CChar.self))
  }
}

extension UnsafePointer: CStringConvertible where Pointee == CChar {
  @inlinable @inline(__always)
  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(self)
  }
}

extension UnsafeMutablePointer: CStringConvertible where Pointee == CChar {
  @inlinable @inline(__always)
  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(self)
  }
}

extension StaticCString: CStringConvertible {
  @inlinable @inline(__always)
  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try body(cString)
  }
}

#if canImport(System)
import System

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
extension FilePath: CStringConvertible {}
#endif
